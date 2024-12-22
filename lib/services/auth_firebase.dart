import 'dart:async';
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

  Future<String> createAccount(
      String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.sendEmailVerification();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<bool> checkMovileSupportFingerprint() async {
    bool isSupport = await auth.canCheckBiometrics;
    return isSupport;
  }

  Future<String> checkFingerprint() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate for fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }
    return isAuthenticated && _auth.currentUser!.emailVerified
        ? "Success"
        : "Email Not Verified";
  }

  Future<String> uploadAvatar(String idUser, File imageFile) async {
    final ref = _database.ref("user").child("imageHastag").child(idUser);
    try {
      if (_auth.currentUser?.photoURL != null) {
        String hastag = "";
        final snapshot = await ref.get();
        final data = Map<String, String>.from(snapshot.value as Map);
        hastag = data["hastag"]!;
        await ImagurService.deleteImage(hastag);
      }
      List<String> image = await ImagurService.uploadImage(imageFile);
      await _auth.currentUser!.updatePhotoURL(image.first);
      final data = {"hastag": image.last};
      await ref.set(data);
      await _auth.currentUser!.reload();
      return "Success";
    } catch (e) {
      return "$e";
    }
  }

  Future<String> loginAccount(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      bool isEmailVerifield = user.user!.emailVerified;
      return isEmailVerifield ? "Success" : "Email Not Verified";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
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
        return "Email and password wrong.";
      } else {
        return "Dont account admin";
      }
    } on FirebaseException catch (e) {
      return "${e.message}";
    }
  }

  Future<bool> checkUserNotNull() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isEmailVerified = user.emailVerified;
      return isEmailVerified;
    }
    return false;
  }

  Future<String> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return 'An error occurred. Please try again.';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<Auth> getUser() async {
    _auth.currentUser!.reload();
    User auth = _auth.currentUser!;
    Auth user = Auth(
      gmail: auth.email!,
      userName: auth.displayName!,
      phone: auth.phoneNumber ?? "",
      image: auth.photoURL ?? "",
    );
    user.setId = auth.uid;
    return user;
  }

  Future<String> changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return "Success";
    } on FirebaseException catch (e) {
      print(e.message);
      return "$e";
    } catch (e) {
      print(e);
      return "$e";
    }
  }

  Future<String> changeName(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name);
      return "Success";
    } on FirebaseException catch (e) {
      print(e.message);
      return "$e";
    } catch (e) {
      print(e);
      return "$e";
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
