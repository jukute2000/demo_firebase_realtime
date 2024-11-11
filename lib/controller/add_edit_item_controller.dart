import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEditItemController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController urlImage = TextEditingController();
  String imagePart = "";
  late String oldImagePart;
  final Map<String, dynamic> dataAgrument;
  late bool isPageAdd;
  String idItem = "";
  String idUser = "";
  final ItemFirebase _itemFirebase = ItemFirebase();

  AddEditItemController({required this.dataAgrument}) {
    isPageAdd = dataAgrument["page"] == "Add" ? true : false;
    idUser = dataAgrument["idUser"];
    if (!isPageAdd) {
      getDataFromHome();
    }
  }
  void getDataFromHome() {
    idItem = dataAgrument["id"];
    title.text = dataAgrument["title"];
    description.text = dataAgrument["description"];
    price.text = dataAgrument["price"].toString();
    oldImagePart = urlImage.text = dataAgrument["urlImage"];
    urlImage.text = oldImagePart.split('/').last;
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    description.dispose();
    price.dispose();
  }

  Future<void> chooseImage() async {
    if (await Permission.storage.request().isGranted) {
      final xFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
      if (xFile != null) {
        imagePart = xFile.path;
        urlImage.text = xFile.name;
      }
    }
  }

  Future<void> onSave() async {
    if (isPageAdd) {
      await _saveAdd();
    } else {
      await _saveEdit();
    }
  }

  Future<void> _saveAdd() async {
    if (await _itemFirebase.addItem(idUser, title.text, description.text,
        int.parse(price.text), imagePart)) {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Sucess", message: "Add item success", isSuccess: true));
      Get.offAndToNamed("/home", result: true);
    } else {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Fail", message: "Add item fail", isSuccess: false));
    }
  }

  Future<void> _saveEdit() async {
    if (oldImagePart != imagePart) {
      imagePart = oldImagePart;
    }
    if (await _itemFirebase.editItem(idUser, idItem, title.text,
        description.text, int.parse(price.text), imagePart)) {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Sucess", message: "Edit item success", isSuccess: true));
      Get.offAndToNamed("/home", result: true);
    } else {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Fail", message: "Edit item fail", isSuccess: false));
    }
  }
}
