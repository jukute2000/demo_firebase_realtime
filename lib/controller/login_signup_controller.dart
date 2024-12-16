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
  bool? isUserNotNull;
  RxBool isLoading = true.obs;
  TextEditingController rePassword = TextEditingController();
  RxBool isOpcusRePassword = true.obs;
  RxBool isPolicy = false.obs;
  bool isSupportFingerprint = false;

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
    isSupportFingerprint = await _auth.checkMovileSupportFingerprint();
    isLoading.value = false;
  }

  Future<void> onSubmit() async {
    if (isPageLogin.value) {
      await onSubmitLogin();
    } else {
      await onSubmitSignIn();
    }
  }

  Future<void> loginFingerPrint() async {
    bool isSuccess = await _auth.checkFingerprint();
    if (isSuccess) {
      Get.offAndToNamed("userHome");
    } else {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Incorrect fingerprint",
          isSuccess: false,
        ),
      );
    }
  }

  void resetTextEdit() {
    gmail.clear();
    username.clear();
    password.clear();
    rePassword.clear();
  }

  Future<void> onSubmitLogin() async {
    if (await _auth.checkAdmin(gmail.text, password.text) == "Success") {
      SnackbarWidget.snackBarWidget(
        title: "Success",
        message: "Login admin success",
        isSuccess: true,
      );
      resetTextEdit();
      Get.offAllNamed("/authorHome");
    } else {
      String message = await _auth.loginAccount(gmail.text, password.text);
      if (message == "Success") {
        SnackbarWidget.snackBarWidget(
          title: "Success",
          message: "Login success",
          isSuccess: true,
        );
        Get.offAndToNamed("/userHome");
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
        Get.offAndToNamed("/authorHome");
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
