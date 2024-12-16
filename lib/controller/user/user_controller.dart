import 'dart:io';

import 'package:demo_firebase_realtime/models/auth_model.dart';
import 'package:demo_firebase_realtime/services/address_firebase.dart';
import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/address_model.dart';
import '../../widgets/snackbar_widget.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSetUpName = false.obs;
  RxBool isSetUpPassword = false.obs;
  RxBool isAddressNull = true.obs;
  late Auth user;
  Address? address;
  final _userFirebase = AuthFirebase();
  final _addressFirebase = AddressFirebase();
  String textName = "";
  String textPhone = "";
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController curentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController reNewpassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    phone.dispose();
    curentPassword.dispose();
    newPassword.dispose();
    reNewpassword.dispose();
  }

  UserController() {
    getUserData();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed("/loginSignup");
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    user = await _userFirebase.getUser();
    address = await _addressFirebase.getAddressStatus1(user.getId!);
    if (address != null) {
      isAddressNull.value = false;
    }
    textName = user.userName;
    textPhone = user.phone;
    name.text = user.userName;
    phone.text = user.phone;
    isLoading.value = false;
  }

  Future<void> getAddressData() async {
    isLoading.value = true;
    address = await _addressFirebase.getAddressStatus1(user.getId!);
    if (address != null) {
      isAddressNull.value = false;
    }
    isLoading.value = false;
  }

  Future<void> changeName() async {
    isLoading.value = true;
    String isSuccess = await _userFirebase.changeName(name.text);
    if (isSuccess == "Success") {
      user = await _userFirebase.getUser();
      textName = user.userName;
      isSetUpName.value = !isSetUpName.value;
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Success", message: "Change name success", isSuccess: true));
    } else {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Fail", message: "Change name failed", isSuccess: false));
    }
    isLoading.value = false;
  }

  Future<void> changePassword() async {
    isLoading.value = true;
    bool isAvailable = true;
    if (curentPassword.text == "" ||
        newPassword.text == "" ||
        reNewpassword.text == "") {
      isAvailable = false;
    }
    if (isAvailable) {
      String isSuccess =
          await _userFirebase.loginAccount(user.gmail, curentPassword.text);
      if (isSuccess == "Success") {
        if (newPassword.text == reNewpassword.text) {
          String isSuc = await _userFirebase.changePassword(newPassword.text);
          if (isSuc == "Success") {
            isSetUpPassword.value = !isSetUpPassword.value;
            curentPassword.clear();
            newPassword.clear();
            reNewpassword.clear();
            Get.showSnackbar(
              SnackbarWidget.snackBarWidget(
                title: "Success",
                message: "Change password success",
                isSuccess: true,
              ),
            );
          } else {
            Get.showSnackbar(
              SnackbarWidget.snackBarWidget(
                title: "Fail",
                message: "Change password failed",
                isSuccess: false,
              ),
            );
          }
        } else {
          Get.showSnackbar(
            SnackbarWidget.snackBarWidget(
              title: "Fail",
              message: "New Password and New Repeat not the same",
              isSuccess: false,
            ),
          );
        }
      } else {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Fail",
            message: "Current password is incorrect",
            isSuccess: false,
          ),
        );
      }
    }
    isLoading.value = false;
  }

  Future<void> chooseSetUp(String type) async {
    if (type == "Name") {
      isSetUpName.value = true;
    } else if (type == "Phone") {
      Get.toNamed("/phone")!.then(
        (value) async {
          if (value) {
            await getUserData();
          }
        },
      );
    } else if (type == "Address") {
      String idUser = user.getId!;
      isAddressNull.value = true;
      Get.toNamed("/address", arguments: {"idUser": idUser})?.then(
        (value) async {
          if (value) {
            await getAddressData();
          }
        },
      );
    } else {
      isSetUpPassword.value = true;
    }
  }

  Future<void> chooseImage() async {
    final isPermissionGranted = await _requestPermissions();
    if (!isPermissionGranted) {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Permission Denied",
          message: "Please enable required permissions to continue.",
          isSuccess: true,
        ),
      );
    }
    isLoading.value = true;
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
            title: "Not Select",
            message: "You not select image",
            isSuccess: false),
      );
    } else {
      File imagePart = File(xFile.path);
      String isSuccess =
          await _userFirebase.uploadAvatar(user.getId!, imagePart);
      if (isSuccess == "Success") {
        user = await _userFirebase.getUser();
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
              title: "Success",
              message: "Update avatar success",
              isSuccess: true),
        );
      }
    }
    isLoading.value = false;
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) return true;
      if (await Permission.photos.request().isGranted) return true;
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) return true;
    }
    return false;
  }
}
