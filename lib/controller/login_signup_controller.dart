import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginSignupController extends GetxController {
  final AuthFirebase _auth = AuthFirebase();
  RxBool isPageLogin = true.obs;
  TextEditingController gmail = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController emailForgetPassword = TextEditingController();
  RxBool isOpcusPassword = true.obs;
  bool? isUserNotNull;
  RxBool isLoading = true.obs;
  TextEditingController rePassword = TextEditingController();
  RxBool isOpcusRePassword = true.obs;
  RxBool isPolicy = false.obs;
  bool isSupportFingerprint = false;
  RxBool isForgetPassword = false.obs;
  static FlutterSecureStorage storge = const FlutterSecureStorage();

  void changeIsForgetPassword(bool isClear) {
    isForgetPassword.value = !isForgetPassword.value;
    if (isClear) emailForgetPassword.clear();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    gmail.clear();
    username.clear();
    password.clear();
    await init();
  }

  @override
  void dispose() {
    super.dispose();
    gmail.dispose();
    username.dispose();
    password.dispose();
    rePassword.dispose();
  }

  Future<void> init() async {
    isUserNotNull = await _auth.checkUserNotNull();
    isSupportFingerprint = await _auth.checkMobileSupportFingerprint();
    if (isUserNotNull! && isSupportFingerprint) await readGmailStorge();
    isLoading.value = false;
  }

  Future<void> onSubmit() async {
    if (isPageLogin.value) {
      await onSubmitLogin();
    } else {
      await onSubmitSignIn();
    }
  }

  Future<void> onLoginGoogle() async {
    String mess = await _auth.loginedGoogle();
    if (mess == "Success") {
      showSnackbar(title: "Success", message: "Login success", isSuccess: true);
      Get.offAndToNamed("/userHome");
    } else {
      showSnackbar(title: "Fail", message: mess, isSuccess: false);
    }
  }

  Future<void> loginFingerPrint() async {
    String isSuccess = await _auth.checkFingerprint();
    if (isSuccess == "Success") {
      Get.offAndToNamed("userHome");
    } else if (isSuccess == "Email Not Verified") {
      await emailNotVerifiled();
    } else {
      showSnackbar(
        title: "Fail",
        message: "Incorrect fingerprint",
        isSuccess: false,
      );
    }
  }

  Future<void> emailNotVerifiled() async {
    showSnackbar(
      title: "Fail",
      message: "Email not verifiled and send email verifiled",
      isSuccess: false,
    );
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  void resetTextEdit() {
    gmail.clear();
    username.clear();
    password.clear();
    rePassword.clear();
  }

  Future<void> forgetPassword() async {
    String result = await _auth.forgetPassword(emailForgetPassword.text);
    if (result == "Success") {
      showSnackbar(
        title: "Success",
        message: "Reset password sent to ${emailForgetPassword.text}",
        isSuccess: true,
      );
    } else {
      showSnackbar(title: "Fail", message: result, isSuccess: false);
    }
    emailForgetPassword.clear();
  }

  Future<void> onSubmitLogin() async {
    if (await _auth.checkAdmin(gmail.text, password.text) == "Success") {
      showSnackbar(
          title: "Success", message: "Login admin success", isSuccess: true);
      resetTextEdit();
      Get.offAllNamed("/authorHome");
    } else {
      String message = await _auth.loginAccount(gmail.text, password.text);
      if (message == "Success") {
        showSnackbar(
            title: "Success", message: "Login success", isSuccess: true);
        saveGmailStorge();
        Get.offAndToNamed("/userHome");
      } else if (message == "Email Not Verified") {
        emailNotVerifiled();
      } else {
        showSnackbar(title: "Fail", message: message, isSuccess: false);
      }
    }
  }

  Future<void> onSubmitSignIn() async {
    if (password.text == rePassword.text) {
      String message =
          await _auth.createAccount(gmail.text, password.text, username.text);
      if (message == "Success") {
        showSnackbar(
            title: "Success", message: "Create success", isSuccess: true);
        changePageLoginOrSignIn();
      } else {
        showSnackbar(title: "Fail", message: message, isSuccess: false);
      }
    }
  }

  Future<void> changePageLoginOrSignIn() async {
    isPageLogin.value = !isPageLogin.value;
    resetTextEdit();
    if (isPageLogin.value) await readGmailStorge();
  }

  void showSnackbar(
      {required String title,
      required String message,
      required bool isSuccess}) {
    Get.showSnackbar(
      SnackbarWidget.snackBarWidget(
        title: title,
        message: message,
        isSuccess: isSuccess,
      ),
    );
  }

  Future<void> readGmailStorge() async {
    gmail.text = await storge.read(key: "user_gmail") ?? "";
  }

  void saveGmailStorge() {
    storge.write(
        key: "user_gmail", value: FirebaseAuth.instance.currentUser!.email);
  }
}
