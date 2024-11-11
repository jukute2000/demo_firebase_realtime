import 'package:demo_firebase_realtime/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> createAccount(
      String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.updateDisplayName("name");
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> loginAccount(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<Auth> getUser() async {
    User auth = _auth.currentUser!;
    auth.reload();
    Auth user = Auth(
      gmail: auth.email!,
      userName: auth.displayName!,
      phone: auth.phoneNumber ?? "",
    );
    user.setId = auth.uid;
    return user;
  }
}
