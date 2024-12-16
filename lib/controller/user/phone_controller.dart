import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../models/auth_model.dart';

class PhoneController extends GetxController {
  RxBool isLoading = true.obs;
  late Auth user;
  final _userDatabase = AuthFirebase();
  String verify = "";
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();

  PhoneController() {
    getDataUser();
    settingPhoneController();
  }

  @override
  void dispose() {
    super.dispose();
    phone.dispose();
    otp.dispose();
  }

  Future<void> getDataUser() async {
    isLoading.value = true;
    user = await _userDatabase.getUser();
    isLoading.value = false;
  }

  void settingPhoneController() {
    phone.addListener(
      () {
        final text = phone.text;
        if (!text.startsWith("+84")) {
          phone.text = "+84";
          phone.selection = TextSelection.fromPosition(
              TextPosition(offset: phone.text.length));
        }
      },
    );
  }

  Future<void> receiveOTP() async {
    isLoading.value = true;
    if (phone.text.length < 4) {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Phone number not entered",
          isSuccess: false,
        ),
      );
    } else {
      verify = await _userDatabase.verifyPhoneNumber(phone.text);
      if (verify.isEmpty) {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Fail",
            message: "Receive OTP failed",
            isSuccess: false,
          ),
        );
      } else {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Success",
            message: "Receive OTP successfully",
            isSuccess: true,
          ),
        );
      }
    }
    isLoading.value = false;
  }

  Future<void> updatePhone() async {
    if (verify.isEmpty) {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Not received otp",
          isSuccess: false,
        ),
      );
    } else if (otp.text == "") {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "OTP not entered",
          isSuccess: false,
        ),
      );
    } else {
      String? isSuccess = await _userDatabase.updateSmsCode(otp.text, verify);
      if (isSuccess == "Success") {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Success",
            message: "Update otp successfully",
            isSuccess: true,
          ),
        );
        Get.offAndToNamed("/user", result: true);
      } else {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Fail",
            message: "Enter wrong OTP",
            isSuccess: false,
          ),
        );
      }
    }
  }
}
