import 'package:demo_firebase_realtime/models/address_model.dart';
import 'package:demo_firebase_realtime/services/address_firebase.dart';
import 'package:demo_firebase_realtime/services/cart_firebase.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/services/order_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/cart_model.dart';
import '../../models/item_model.dart';

class OrderController extends GetxController {
  TextEditingController messageForShop = TextEditingController();
  FocusNode focusNodeMessageForShop = FocusNode();
  RxBool isLoading = false.obs;
  String idProducts = "";
  String idUser = "";
  bool isCart = true;
  int totalPriceProduct = 0;
  int totalQuantityProduct = 0;
  List<String> products = [];
  RxList<Item> items = <Item>[].obs;
  RxList<Cart> carts = <Cart>[].obs;
  RxBool isAddressNull = true.obs;
  Address? address;
  final _itemFirebase = ItemFirebase();
  final _cartFirebase = CartFirebase();
  final _addressFirebase = AddressFirebase();
  final _orderFirebase = OrderFirebase();

  @override
  void dispose() {
    messageForShop.dispose();
    focusNodeMessageForShop.dispose();
    isLoading.close();
    isAddressNull.close();
    items.close();
    carts.close();
    address = null;
    products.clear();
    super.dispose();
  }

  final Map<String, String> data;
  OrderController({required this.data}) {
    isLoading.value = true;
    idUser = data["idUser"] ?? "";
    if (data["isCart"] == "false") {
      isCart = false;
    }
    if (isCart) {
      idProducts = data["idItemChoosed"] ?? "";
      if (idProducts.isNotEmpty) {
        products = idProducts
            .split(",")
            .map(
              (e) => e.trim(),
            )
            .toList();
      }
    } else {
      products.add(data["idItemChoosed"] ?? "");
    }
    getData();
  }

  Future<void> getData() async {
    isLoading.value = true;
    carts.clear();
    items.clear();
    totalPriceProduct = 0;
    totalQuantityProduct = 0;
    if (isCart) {
      for (var element in products) {
        Cart? cart = await _cartFirebase.getUserCartById(idUser, element);
        if (cart != null) carts.add(cart);
      }
      carts.forEach(
        (element) {
          totalPriceProduct += element.totalPrice;
          totalQuantityProduct += element.quantity;
        },
      );
    }
    for (var element in products) {
      Item? item = await _itemFirebase.getItemById(element);
      if (item != null) items.add(item);
    }
    await getDataAddress();
    isLoading.value = false;
  }

  Future<void> getDataAddress() async {
    isLoading.value = true;
    address = await _addressFirebase.getAddressStatus1(idUser);
    if (address != null) {
      isAddressNull.value = false;
    }
    isLoading.value = false;
  }

  Future<void> order() async {
    if (!isCart) {
      carts.add(Cart(
          idItem: items.first.id, quantity: 1, totalPrice: items.first.price));
    }
    List<Map<String, dynamic>> dataCarts =
        carts.map((element) => element.ToJson()).toList();
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('HH:mm dd-MM-yyyy').format(now);
    bool isSuccess = await _orderFirebase.createOrder(
      idUser,
      formattedDateTime,
      dataCarts,
      messageForShop.text,
    );

    if (isSuccess) {
      for (var element in carts) {
        _cartFirebase.deleteItemCart(idUser, element.idItem);
      }
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Success",
          message: "Order creation successfully",
          isSuccess: isSuccess,
        ),
      );
      Get.offAllNamed("/userHome");
    } else {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Order creation failed",
          isSuccess: isSuccess,
        ),
      );
    }
  }

  Future<void> movePageAdress() async {
    Get.toNamed("/address", arguments: {"idUser": idUser})!.then(
      (value) async {
        if (value) {
          await getDataAddress();
        }
      },
    );
  }
}
