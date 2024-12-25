import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:demo_firebase_realtime/models/auth_model.dart';
import 'package:demo_firebase_realtime/services/imagur_service.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final LocalAuthentication auth = LocalAuthentication();
  String verifyId = "";

  Future<String?> getUserToken() async {
    User? user = _auth.currentUser;
    return user != null ? await user.getIdToken() : null;
  }

  Future<String?> getFreshToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return await user.getIdToken(true);
    }
    return null;
  }

  Future<String> createAccount(
      String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.sendEmailVerification();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Unknown error';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<bool> checkMobileSupportFingerprint() async {
    return await auth.canCheckBiometrics;
  }

  Future<String> checkFingerprint() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }
    if (isAuthenticated) {
      if (_auth.currentUser!.emailVerified) {
        return "Success";
      } else {
        return "Email not verified. Please verify your email first.";
      }
    } else {
      return "Fingerprint authentication failed";
    }
  }

  Future<String> uploadAvatar(String idUser, File imageFile) async {
    final ref = _database.ref("user").child("imageHashtag").child(idUser);
    try {
      if (_auth.currentUser?.photoURL != null) {
        String hashtag = "";
        final snapshot = await ref.get();
        final data = Map<String, String>.from(snapshot.value as Map);
        hashtag = data["hashtag"]!;
        await ImagurService.deleteImage(hashtag);
      }
      List<String> image = await ImagurService.uploadImage(imageFile);
      await _auth.currentUser!.updatePhotoURL(image.first);
      final data = {"hashtag": image.last};
      await ref.set(data);
      await _auth.currentUser!.reload();
      return "Success";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> loginAccount(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user!.emailVerified ? "Success" : "Email Not Verified";
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Unknown error';
    }
  }

  Future<String> checkAdmin(String email, String password) async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref("admin").get();
      if (snapshot.exists) {
        final data = Map<String, String>.from(snapshot.value as Map);
        if (data["userName"] == _generateMd5(email) &&
            data["password"] == _generateMd5(password)) {
          return "Success";
        }
        return "Incorrect email or password";
      } else {
        return "Admin account not found";
      }
    } on FirebaseException catch (e) {
      return "Error: ${e.message}";
    }
  }

  Future<bool> checkUserNotNull() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null && user.emailVerified;
  }

  Future<String> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with this email';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address';
      } else {
        return 'An error occurred. Please try again';
      }
    }
  }

  Future<Auth> getUser() async {
    await _auth.currentUser!.reload();
    User auth = _auth.currentUser!;
    return Auth(
      gmail: auth.email!,
      userName: auth.displayName!,
      phone: auth.phoneNumber ?? "",
      image: auth.photoURL ?? "",
    )..setId = auth.uid;
  }

  Future<String> changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return "Success";
    } on FirebaseException catch (e) {
      return "Error: ${e.message}";
    }
  }

  Future<String> changeName(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name);
      return "Success";
    } on FirebaseException catch (e) {
      return "Error: ${e.message}";
    }
  }

  Future<String> verifyPhoneNumber(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Failed To Verify Phone Number",
            message: "${error.message}",
            isSuccess: false,
          ),
        );
      },
      codeSent: (verificationId, forceResendingToken) {
        verifyId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verifyId = verificationId;
      },
    );
    return verifyId;
  }

  Future<String?> updateSmsCode(String smsCode, String verify) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verify, smsCode: smsCode.trim());
      await _auth.currentUser!.updatePhoneNumber(credential);
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
