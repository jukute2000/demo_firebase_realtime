import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/models/order_model.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/services/order_firebase.dart';
import 'package:demo_firebase_realtime/services/type_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../models/cart_model.dart';
import '../../models/type_item_model.dart';

class AuthorHomeController extends GetxController {
  final ItemFirebase _itemFirebase = ItemFirebase();
  final OrderFirebase _orderFirebase = OrderFirebase();
  final TypeFirebase _typeFirebase = TypeFirebase();
  TextEditingController searchOrder = TextEditingController();
  TextEditingController searchProduct = TextEditingController();
  TextEditingController type = TextEditingController();
  List<Item> items = [];
  RxBool isItemsEmpty = true.obs;
  RxBool isLoading = true.obs;
  RxInt selectPage = 0.obs;
  RxBool isOrdersNull = true.obs;
  RxBool isAddType = false.obs;
  RxBool isEditType = false.obs;
  RxBool isSearchOrder = false.obs;
  RxBool isTypeProductNull = true.obs;
  RxBool isOrderSearchNull = true.obs;
  RxList<String> statusOrders = <String>[].obs;
  List<Order> orders = [];
  List<TypeItem> types = [];
  List<String> typesProduct = [];
  String idTypeEdit = "";
  List<List<Item>> itemOrder = [];
  RxList<int> listStatusOrders = <int>[].obs;
  Map<int, String> statusData = {
    1: "Store is processing",
    2: "Order completed"
  };
  RxInt statusTypeSelect = 0.obs;
  Map<int, String> statusTypeData = {0: "Lock", 1: "Open"};

  Future<void> canelAddOrEditType() async {
    if (isAddType.value) {
      isAddType.value = !isAddType.value;
      statusTypeSelect.value = 0;
    } else {
      isEditType.value = !isEditType.value;
      idTypeEdit = "";
      statusTypeSelect.value = 0;
    }
    type.clear();
  }

  Future<void> editButton(String idType, String nameType, int status) async {
    idTypeEdit = idType;
    type.text = nameType;
    statusTypeSelect.value = status;
    isEditType.value = true;
  }

  Future<void> editType() async {
    isLoading.value = true;
    await _typeFirebase.editType(idTypeEdit, type.text, statusTypeSelect.value);
    canelAddOrEditType();
    await getTypeData();
    isLoading.value = false;
  }

  Future<void> addType() async {
    if (type.text == "") {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Type field is empty",
          isSuccess: false,
        ),
      );
    } else {
      await _typeFirebase.addType(type.text, statusTypeSelect.value).then(
        (value) async {
          Get.showSnackbar(
            SnackbarWidget.snackBarWidget(
              title: "Success",
              message: "Add type success",
              isSuccess: true,
            ),
          );
          canelAddOrEditType();
          isLoading.value = true;
          await getTypeData();
          isLoading.value = false;
        },
      );
    }
  }

  Future<void> addButton(int index) async {
    if (index == 0) {
      Get.toNamed("/authorAddEdit", arguments: {
        "page": "Add",
      })!
          .then(
        (value) async {
          await getItemData();
        },
      );
    } else {
      isAddType.value = !isAddType.value;
    }
  }

  Future<void> deleteItem(String id, String tagImage) async {
    isLoading.value = true;
    await _itemFirebase.deleteItem(id, tagImage);
    await getItemData();
    isLoading.value = false;
  }

  Future<void> choosePage(int value) async {
    selectPage.value = value;
    if (value == 0) {
      await getItemData();
    } else if (value == 1) {
      await getAllOrder();
    } else {
      isLoading.value = true;
      await getTypeData();
      isLoading.value = false;
    }
  }

  Future<void> getProductData() async {
    isLoading.value = true;
    await getItemData();
    isLoading.value = false;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAndToNamed("/loginSignup");
  }

  Future<void> getTypeData() async {
    types.clear();
    isTypeProductNull.value = true;
    types = await _typeFirebase.getAllType();
    if (types.isNotEmpty) {
      isTypeProductNull.value = false;
    }
  }

  Future<void> getItemData() async {
    items = await _itemFirebase.fetchItems(false);
    typesProduct.clear();
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      typesProduct.add(type!.nameType);
    }
    searchProduct.clear();
    isItemsEmpty.value = items.isEmpty;
  }

  Future<void> getItemDataByIdType(String idType) async {
    isLoading.value = true;
    items = await _itemFirebase.getItemsByIdtype(false, idType);
    typesProduct.clear();
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      typesProduct.add(type!.nameType);
    }
    isItemsEmpty.value = items.isEmpty;
    isLoading.value = false;
  }

  Future<void> getItemDataBySearch() async {
    isLoading.value = true;
    items = await _itemFirebase.getItemsBySearch(false, searchProduct.text);
    typesProduct.clear();
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      typesProduct.add(type!.nameType);
    }
    isItemsEmpty.value = items.isEmpty;
    isLoading.value = false;
  }

  Future<void> getOrderByDate(BuildContext context, width, height) async {
    List<DateTime?>? listDate = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range),
      dialogSize: Size(
        width,
        height,
      ),
      borderRadius: BorderRadius.circular(10),
    );
    if (listDate != null) {
      isLoading.value = true;
      isSearchOrder.value = false;
      searchOrder.text = "";
      itemOrder.clear();
      listStatusOrders.clear();
      orders = await _orderFirebase.getOrderByDate(listDate);
      print(orders.length);
      if (orders.isNotEmpty) {
        isOrdersNull.value = false;
      } else {
        isOrdersNull.value = true;
      }
      if (!isOrdersNull.value) {
        for (var element in orders) {
          List<Item> items = [];
          for (var cart in element.carts) {
            Item? item = await _itemFirebase.getItemById(cart.idItem);
            if (item != null) {
              items.add(item);
            }
          }
          if (element.status == 1) {
            statusOrders.add("Store is processing");
          } else {
            statusOrders.add("Order completed");
          }
          listStatusOrders.add(element.status);
          itemOrder.add(items);
        }
      }
      isLoading.value = false;
    }
  }

  Future<void> getOrderBySearch() async {
    isLoading.value = true;
    isOrderSearchNull = true.obs;
    isSearchOrder.value = true;
    itemOrder.clear();
    listStatusOrders.clear();
    if (searchOrder.text != "") {
      orders = await _orderFirebase.getOrderBySearch(searchOrder.text);
      if (orders.isNotEmpty) {
        isSearchOrder.value = false;
        for (var element in orders) {
          List<Item> items = [];
          for (var cart in element.carts) {
            Item? item = await _itemFirebase.getItemById(cart.idItem);
            if (item != null) {
              items.add(item);
            }
          }
          if (element.status == 1) {
            statusOrders.add("Store is processing");
          } else {
            statusOrders.add("Order completed");
          }
          listStatusOrders.add(element.status);
          itemOrder.add(items);
        }
      }
    }
    isLoading.value = false;
  }

  Future<void> getAllOrder() async {
    isLoading.value = true;
    isSearchOrder.value = false;
    searchOrder.text = "";
    itemOrder.clear();
    listStatusOrders.clear();
    orders = await _orderFirebase.getAllOrders();
    if (orders.isNotEmpty) {
      isOrdersNull.value = false;
    } else {
      isOrdersNull.value = true;
    }
    if (!isOrdersNull.value) {
      for (var element in orders) {
        List<Item> items = [];
        for (var cart in element.carts) {
          Item? item = await _itemFirebase.getItemById(cart.idItem);
          if (item != null) {
            items.add(item);
          }
        }
        if (element.status == 1) {
          statusOrders.add("Store is processing");
        } else {
          statusOrders.add("Order completed");
        }
        listStatusOrders.add(element.status);
        itemOrder.add(items);
      }
    }
    isLoading.value = false;
  }

  Future<void> editStatusOrder(String idOrder, String date, List<Cart> carts,
      int status, String message) async {
    await _orderFirebase
        .editOrderStatus(idOrder, date, carts, status, message)
        .then(
      (value) async {
        await getAllOrder();
      },
    );
  }

  Future<void> getDataProductAndType() async {
    isLoading.value = true;
    await getItemData();
    await getTypeData();
    isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getDataProductAndType();
  }
}