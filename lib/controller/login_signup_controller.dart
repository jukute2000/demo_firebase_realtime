import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginSignupController extends GetxController {
  final AuthFirebase _auth = AuthFirebase();

  RxBool isPageLogin = true.obs;
  TextEditingController gmail = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool isOpcusPassword = true.obs;
  TextEditingController rePassword = TextEditingController();
  RxBool isOpcusRePassword = true.obs;
  RxBool isPolicy = false.obs;

  @override
  void dispose() {
    super.dispose();
    gmail.dispose();
    username.dispose();
    password.dispose();
    rePassword.dispose();
  }

  Future<void> onSubmit() async {
    if (isPageLogin.value) {
      await onSubmitLogin();
    } else {
      await onSubmitSignIn();
    }
  }

  Future<void> onSubmitLogin() async {
    String message = await _auth.loginAccount(gmail.text, password.text);
    if (message == "Success") {
      SnackbarWidget.snackBarWidget(
        title: "Success",
        message: "Login success",
        isSuccess: true,
      );
      Get.offAndToNamed("/home");
    } else {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: message,
          isSuccess: false,
        ),
      );
    }
  }

  Future<void> onSubmitSignIn() async {
    if (password.text == rePassword.text) {
      String message =
          await _auth.createAccount(gmail.text, password.text, username.text);
      if (message == "Success") {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Success",
            message: "Create success",
            isSuccess: true,
          ),
        );
        Get.offAndToNamed("/home");
      } else {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Fail",
            message: message,
            isSuccess: false,
          ),
        );
      }
    }
  }

  void changePageAddEdit() {
    isPageLogin.value = !isPageLogin.value;
    reset();
  }

  void reset() {
    gmail.clear();
    username.clear();
    password.clear();
    rePassword.clear();
  }
}
