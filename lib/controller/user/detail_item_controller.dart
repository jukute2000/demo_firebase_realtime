import 'package:demo_firebase_realtime/services/cart_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailItemController extends GetxController {
  String title = "";
  int price = 0;
  String description = "";
  String urlImage = "";
  String idItem = "";
  String idUser = "";

  final CartFirebase _cartFirebase = CartFirebase();
  late Map<String, dynamic> data;

  DetailItemController(Map<String, dynamic> data) {
    idUser = data["idUser"] ?? "";
    idItem = data["idItem"] ?? "";
    title = data["title"] ?? "";
    price = data["price"] ?? 0;
    description = data["decription"] ?? "";
    urlImage = data["urlImage"] ?? "";
  }

  Future<void> addItemCart() async {
    final isSuccess = await _cartFirebase.addItemCart(
        idUser: idUser, idItem: idItem, price: price);
    Get.showSnackbar(
      SnackbarWidget.snackBarWidget(
        title: isSuccess ? "Success" : "Fail",
        message: isSuccess ? "Successed add product" : "Failed add product",
        isSuccess: isSuccess,
      ),
    );
  }

  Future<void> buyItem() async {
    Get.back();
    Get.toNamed(
      "/order",
      arguments: {"idUser": idUser, "idItemChoosed": idItem, "isCart": "false"},
    );
  }

  Future<void> getDiablog() async {
    Get.defaultDialog(
      title: "Confirm product purchase",
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Do you have to buy a product?"))],
      ),
      confirm: TextButton(
        onPressed: () {
          buyItem();
        },
        child: const Text(
          "Confirm",
          style: TextStyle(color: Colors.green),
        ),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
