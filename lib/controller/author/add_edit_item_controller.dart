import 'dart:io';
import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/services/type_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthorAddEditItemController extends GetxController {
  final ItemFirebase _itemFirebase = ItemFirebase();
  final _typeFirebase = TypeFirebase();
  RxBool isLoading = false.obs;
  String idItem = "";
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  Map<int, String> statusData = {0: "Out of stock", 1: "In stock"};
  List<Map<String, String>> typeData = [];
  RxString imageUrl = "".obs;
  String idType = "";
  File? imagePart;
  bool isPick = false;
  String tagImage = "";
  RxInt status = 0.obs;
  RxInt typeSelected = 0.obs;
  final Map<String, dynamic> dataAgrument;
  late bool isPageAdd;

  AuthorAddEditItemController({required this.dataAgrument}) {
    isPageAdd = dataAgrument["page"] == "Add" ? true : false;
    if (!isPageAdd) {
      getDataFromHome();
    }
    getTypeProduct();
  }
  Future<void> getTypeProduct() async {
    isLoading.value = true;
    typeData.clear();
    bool isContain = true;
    typeSelected.value = 0;
    List<TypeItem> types = await _typeFirebase.getAllTypeOpen();
    for (var type in types) {
      if (!isPageAdd && isContain && type.idType != idType) {
        typeSelected.value++;
      } else {
        isContain = false;
      }
      typeData.add(type.toMap());
    }
    isLoading.value = false;
  }

  void getDataFromHome() {
    idItem = dataAgrument["id"] ?? '';
    idType = dataAgrument["idType"] ?? '';
    title.text = dataAgrument["title"] ?? '';
    description.text = dataAgrument["description"] ?? '';
    price.text = (dataAgrument["price"] ?? '').toString();
    imageUrl.value = dataAgrument["urlImage"] ?? '';
    tagImage = dataAgrument["tagImage"] ?? '';
    status.value = dataAgrument["status"] ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    description.dispose();
    price.dispose();
  }

  Future<void> chooseImage() async {
    if (await _checkAndRequestPermission()) {
      final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        imageUrl.value = xFile.path;
        imagePart = File(xFile.path);
        isPick = true;
      } else {
        _showSnackbar("Error", "No image selected.");
      }
    }
  }

  Future<bool> _checkAndRequestPermission() async {
    final isPermissionGranted = await _requestPermissions();
    if (!isPermissionGranted) {
      _showSnackbar("Permission Denied",
          "Please enable required permissions to continue.");
    }
    return isPermissionGranted;
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

  Future<void> onSave() async {
    if (_validateInputs()) {
      isLoading.value = true;
      if (isPageAdd) {
        await _saveAdd();
      } else {
        await _saveEdit();
      }
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (title.text.isEmpty ||
        description.text.isEmpty ||
        price.text.isEmpty ||
        imageUrl.value.isEmpty) {
      _showSnackbar("Invalid Input", "All fields are required.");
      return false;
    }
    return true;
  }

  Future<void> _saveAdd() async {
    final success = await _itemFirebase.addItem(
        title: title.text,
        idType: typeData[typeSelected.value].keys.single,
        description: description.text,
        price: int.parse(price.text),
        imageFile: imagePart!,
        status: status.value);
    _showResultSnackbar(success, "Add item success", "Add item fail");
  }

  Future<void> _saveEdit() async {
    final isSuccess = isPick
        ? await _itemFirebase.editItem(
            id: idItem,
            title: title.text,
            idType: typeData[typeSelected.value].keys.single,
            description: description.text,
            price: int.parse(price.text),
            imageFile: imagePart!,
            status: status.value)
        : await _itemFirebase.editItemNotPick(
            id: idItem,
            title: title.text,
            idType: typeData[typeSelected.value].keys.single,
            description: description.text,
            price: int.parse(price.text),
            urlImage: imageUrl.value,
            tagImage: tagImage,
            status: status.value);
    _showResultSnackbar(isSuccess, "Edit item success", "Edit item fail");
  }

  void _showResultSnackbar(bool isSuccess, String successMsg, String failMsg) {
    _showSnackbar(
        isSuccess ? "Success" : "Fail", isSuccess ? successMsg : failMsg);
    if (isSuccess) Get.offAllNamed("/authorHome");
  }

  void _showSnackbar(String title, String message) {
    Get.showSnackbar(SnackbarWidget.snackBarWidget(
      title: title,
      message: message,
      isSuccess: title == "Success",
    ));
  }
}
