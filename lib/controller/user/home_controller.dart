import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:demo_firebase_realtime/models/auth_model.dart';
import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:demo_firebase_realtime/services/order_firebase.dart';
import 'package:demo_firebase_realtime/services/type_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/item_model.dart';
import '../../models/order_model.dart';

class UserHomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isItemEmpty = true.obs;
  RxInt pageSelect = 0.obs;
  RxBool isOrdersNull = true.obs;
  RxList<String> statusOrders = <String>[].obs;
  TextEditingController searchItem = TextEditingController();
  TextEditingController searchOrder = TextEditingController();
  final _itemFirebase = ItemFirebase();
  final _userFirebase = AuthFirebase();
  final _orderFirebase = OrderFirebase();
  final _typeFirebase = TypeFirebase();
  List<String> types = [];
  List<TypeItem> typesAll = [];
  List<Item> items = [];
  List<List<Item>> itemOrder = [];
  List<Order>? orders;
  late Auth user;
  Map<int, String> statusOrderData = {
    0: "All",
    1: "Store is processing",
    2: "Order completed"
  };
  @override
  Future<void> onInit() async {
    super.onInit();
    getDataItems();
  }

  Future<void> getTypeProduct() async {
    typesAll = await _typeFirebase.getAllType();
  }

  Future<void> moveUser() async {
    Get.toNamed("/user")!.then(
      (value) async {
        if (value) {
          isLoading.value = true;
          await getUser();
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> getItemDataByIdType(String idType) async {
    isLoading.value = true;
    items = await _itemFirebase.getItemsByIdtype(false, idType);
    types.clear();
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      types.add(type!.nameType);
    }
    isItemEmpty.value = items.isEmpty;
    isLoading.value = false;
  }

  Future<void> getUser() async {
    user = await _userFirebase.getUser();
  }

  Future<void> getDataItems() async {
    isLoading.value = true;
    types.clear();
    searchItem.clear();
    items = await _itemFirebase.fetchItems(true);
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      types.add(type!.nameType);
    }
    if (items.isNotEmpty) {
      isItemEmpty.value = false;
    }
    await getUser();
    await getTypeProduct();
    isLoading.value = false;
  }

  Future<void> getDataItemsBySearch() async {
    isLoading.value = true;
    types.clear();
    items = await _itemFirebase.getItemsBySearch(true, searchItem.text);
    for (var item in items) {
      TypeItem? type = await _typeFirebase.getTypeById(item.idType);
      types.add(type!.nameType);
    }
    if (items.isNotEmpty) {
      isItemEmpty.value = false;
    }
    isLoading.value = false;
  }

  Future<Item?> getDataItemById(String idItem) async {
    Item? dataItem = await _itemFirebase.getItemById(idItem);
    return dataItem;
  }

  Future<bool> getItemOrder() async {
    List<String> orderHasProductNull = [];
    for (var order in orders!) {
      for (var cart in order.carts) {
        Item? item = await _itemFirebase.getItemById(cart.idItem);
        if (item == null) {
          orderHasProductNull.add(order.idOrder);
          break;
        }
      }
    }
    if (orderHasProductNull.isEmpty) {
      for (var e in orderHasProductNull) {
        _orderFirebase.deleteOrderById(user.getId!, e);
      }
      return true;
    }
    return false;
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
      orders = await _orderFirebase.getOrderByDate(listDate);
      itemOrder.clear();
      statusOrders.clear();
      searchOrder.clear();
      isOrdersNull.value = orders!.isEmpty;
      if (!isOrdersNull.value) {
        bool isOrderHasProductNull = await getItemOrder();
        if (!isOrderHasProductNull) {
          orders = await _orderFirebase.getOrders(user.getId!);
        }
        for (var order in orders!) {
          List<Item> tmp = [];
          for (var cart in order.carts) {
            Item? tmpItem = await getDataItemById(cart.idItem);
            if (tmpItem != null) {
              tmp.add(tmpItem);
            }
          }
          if (order.status == 1) {
            statusOrders.add("Store is processing");
          } else if (order.status == 2) {
            statusOrders.add("Order completed");
          }
          itemOrder.add(tmp);
        }
      }
      isLoading.value = false;
    }
  }

  Future<void> getDataOrders() async {
    isLoading.value = true;
    orders = await _orderFirebase.getOrders(user.getId!);
    itemOrder.clear();
    statusOrders.clear();
    searchOrder.clear();
    isOrdersNull.value = orders!.isEmpty;
    if (!isOrdersNull.value) {
      bool isOrderHasProductNull = await getItemOrder();
      if (!isOrderHasProductNull) {
        orders = await _orderFirebase.getOrders(user.getId!);
      }
      for (var order in orders!) {
        List<Item> tmp = [];
        for (var cart in order.carts) {
          Item? tmpItem = await getDataItemById(cart.idItem);
          if (tmpItem != null) {
            tmp.add(tmpItem);
          }
        }
        if (order.status == 1) {
          statusOrders.add("Store is processing");
        } else if (order.status == 2) {
          statusOrders.add("Order completed");
        }
        itemOrder.add(tmp);
      }
    }
    isLoading.value = false;
  }

  Future<void> getDataOrdersBySearch() async {
    if (searchOrder.text != "") {
      isLoading.value = true;
      orders = await _orderFirebase.getOrdersUserBySearch(
        user.getId!,
        searchOrder.text,
      );
      itemOrder.clear();
      statusOrders.clear();
      isOrdersNull.value = orders!.isEmpty;
      if (!isOrdersNull.value) {
        bool isOrderHasProductNull = await getItemOrder();
        if (!isOrderHasProductNull) {
          orders = await _orderFirebase.getOrders(user.getId!);
        }
        for (var order in orders!) {
          List<Item> tmp = [];
          for (var cart in order.carts) {
            Item? tmpItem = await getDataItemById(cart.idItem);
            if (tmpItem != null) {
              tmp.add(tmpItem);
            }
          }
          if (order.status == 1) {
            statusOrders.add("Store is processing");
          } else if (order.status == 2) {
            statusOrders.add("Order completed");
          }
          itemOrder.add(tmp);
        }
      }
      isLoading.value = false;
    } else {
      await getDataOrders();
    }
  }

  Future<void> getDataOrdersByStatus({required int value}) async {
    if (value == 0) {
      getDataOrders();
    } else {
      isLoading.value = true;
      orders = await _orderFirebase.getOrdersUserByStatus(
        user.getId!,
        value,
      );
      itemOrder.clear();
      statusOrders.clear();
      isOrdersNull.value = orders!.isEmpty;
      if (!isOrdersNull.value) {
        bool isOrderHasProductNull = await getItemOrder();
        if (!isOrderHasProductNull) {
          orders = await _orderFirebase.getOrders(user.getId!);
        }
        for (var order in orders!) {
          List<Item> tmp = [];
          for (var cart in order.carts) {
            Item? tmpItem = await getDataItemById(cart.idItem);
            if (tmpItem != null) {
              tmp.add(tmpItem);
            }
          }
          if (order.status == 1) {
            statusOrders.add("Store is processing");
          } else if (order.status == 2) {
            statusOrders.add("Order completed");
          }
          itemOrder.add(tmp);
        }
      }
      isLoading.value = false;
    }
  }

  Future<void> choosePage(int selectPage) async {
    pageSelect.value = selectPage;
    if (pageSelect.value == 0) {
      await getDataItems();
    } else if (pageSelect.value == 1) {
      await getDataOrders();
    }
  }
}
