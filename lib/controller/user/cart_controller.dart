import 'package:demo_firebase_realtime/models/cart_model.dart';
import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:demo_firebase_realtime/services/cart_firebase.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/services/type_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:get/get.dart';

import '../../models/item_model.dart';

class CartController extends GetxController {
  String idUser = "";
  List<Cart> carts = [];
  //lưu các cart để in ra
  List<Item> itemsCart = [];
  //lưu các item không null
  List<String> itemsCartNull = [];
  //lưu các id các item null
  RxList isSelectEdit = [].obs;
  //thuộc tính dùng để lưu các cart được chọn để edit
  RxList quantityItems = [].obs;
  //lưu số lượng các cart để thay đổi khi edit
  RxList totalPriceItems = [].obs;
  //lưu tổng giá trị thay đổi của cart để thay đổi khi edit
  RxMap<String, bool> chooseItem = <String, bool>{}.obs;
  //lưu các giá trị được chọn dùng khi chọn để thanh toán nhiếu cart 1 lúc
  RxBool isChoose = false.obs;
  //lưu dùng để biến đổi giao diện khi chọn click nút chọn nhiều cart để thanh toán
  bool isCartEmpty = false;
  //dùng để biểu hiện xem có cart nào bị rỗng không có thì mới thực hiện function để xóa
  final Map<String, dynamic> data;
  //dùng để nhận các giá trị truyền từ home
  final ItemFirebase _itemFirebase = ItemFirebase();
  final CartFirebase _cartFirebase = CartFirebase();
  final TypeFirebase _typeFirebase = TypeFirebase();
  List<String> listTypeProduct = [];
  RxBool isLoading = true.obs;
  String cartsChoosed = "";

  CartController({required this.data}) {
    idUser = data["idUser"] ?? "";
    getCartData();
  }
  void addRemoveQuantity(int index, bool isAdd) {
    //lệnh dùng để thêm xóa số lượng sản phẩm
    if (isAdd) {
      quantityItems[index] = quantityItems[index] + 1;
      totalPriceItems[index] = quantityItems[index] * itemsCart[index].price;
    } else {
      if (quantityItems[index] >= 1) {
        quantityItems[index] = quantityItems[index] - 1;
        totalPriceItems[index] = quantityItems[index] * itemsCart[index].price;
      }
    }
  }

  void cancelEdit(int index) {
    //thực hiện chức năng cancel Edit và phục hồi các số lượng như cũ
    quantityItems[index] = carts[index].quantity;
    totalPriceItems[index] = carts[index].totalPrice;
  }

  void changeIsSelectEdit(int index) {
    isSelectEdit[index] = !isSelectEdit[index];
  }

  void chooseCart() {
    isChoose.value = !isChoose.value;
    chooseItem.forEach(
      (key, value) => chooseItem[key] = false,
    );
  }

  void addChoosedCarts(String cartChoosed) {
    if (cartsChoosed == "") {
      cartsChoosed = cartChoosed;
    } else {
      cartsChoosed += ",$cartChoosed";
    }
  }

  Future<void> buyCart(String idItem) async {
    Get.toNamed(
      "/order",
      arguments: {"idUser": idUser, "idItemChoosed": idItem},
    );
  }

  Future<void> buyCarts() async {
    try {
      isLoading.value = true;
      cartsChoosed = "";

      for (var entry in chooseItem.entries) {
        if (entry.value) {
          addChoosedCarts(entry.key);
        }
      }

      if (cartsChoosed.isEmpty) {
        Get.showSnackbar(
          SnackbarWidget.snackBarWidget(
            title: "Error",
            message: "Please select at least one item to proceed.",
            isSuccess: false,
          ),
        );
        return;
      }
      chooseCart();
      Get.toNamed("/order",
              arguments: {"idUser": idUser, "idItemChoosed": cartsChoosed})!
          .then(
        (value) {
          getCartData();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitEditItems(int index) async {
    String isSuccess = await _cartFirebase.editItemCart(
      idUser: idUser,
      idItem: itemsCart[index].id,
      quantity: quantityItems[index],
      totalPrice: totalPriceItems[index],
    );
    if (isSuccess == "success") {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Success", message: "Edit cart success", isSuccess: true));
      getCartData();
    } else {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "Fail", message: "Edit cart fail", isSuccess: false));
    }
  }

  Future<void> getItemCart() async {
    for (final element in carts) {
      Item? item = await _itemFirebase.getItemById(element.idItem);
      if (item == null) {
        itemsCartNull.add(element.idItem);
      } else {
        itemsCart.add(item);
        TypeItem? type = await _typeFirebase.getTypeById(item.idType);
        listTypeProduct.add(type!.nameType);
      }
    }
    if (itemsCartNull.isNotEmpty) {
      for (final idItem in itemsCartNull) {
        await _cartFirebase.deleteItemCart(idUser, idItem);
      }
      carts = await _cartFirebase.getUserCart(idUser);
    }
    for (var element in carts) {
      chooseItem.addAll({element.idItem: false});
    }
  }

  Future<void> getCartData() async {
    try {
      isLoading.value = true;
      itemsCart.clear();
      itemsCartNull.clear();
      carts = await _cartFirebase.getUserCart(idUser);
      isCartEmpty = carts.isEmpty;
      listTypeProduct = [];

      if (!isCartEmpty) {
        await getItemCart();
      }
      quantityItems.value = List.generate(
        carts.length,
        (index) => carts[index].quantity,
      );
      totalPriceItems.value = List.generate(
        carts.length,
        (index) => carts[index].totalPrice,
      );
      isSelectEdit.value = List.generate(
        carts.length,
        (index) => false,
      );
    } catch (e) {
      print("Error fetching cart data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
