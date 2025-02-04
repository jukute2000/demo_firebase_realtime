import 'package:demo_firebase_realtime/models/cart_model.dart';
import 'package:demo_firebase_realtime/services/token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../widgets/snackbar_widget.dart';

class OrderFirebase {
  final _database = FirebaseDatabase.instance;
  final _tokenService = TokenService();

  Future<bool> checkToken() async {
    bool isValidToken = await _tokenService.checkToken();
    if (!isValidToken) {
      Get.showSnackbar(SnackbarWidget.snackBarWidget(
          title: "False", message: "Please log in again", isSuccess: false));
      FirebaseAuth.instance.signOut();
      Get.offAllNamed("/loginSignup");
      return true;
    }
    return false;
  }

  Future<bool> createOrder(String idUser, String date,
      List<Map<String, dynamic>> dataCarts, String message) async {
    if (await checkToken()) return false;
    final data = {
      "date": date,
      "carts": dataCarts,
      "status": 1,
      "message": message
    };
    try {
      await _database.ref("order").child(idUser).push().set(data);
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool checkInDay(DateTime date, List<DateTime?>? listDate) {
    if (listDate!.length == 2) {
      if (date.isAfter(listDate.first!.subtract(const Duration(seconds: 1))) &&
          date.isBefore(listDate.last!.add(const Duration(seconds: 1)))) {
        return true;
      }
    } else if (listDate.length == 1 &&
        listDate.first!.year == date.year &&
        listDate.first!.month == date.month &&
        listDate.first!.day == date.day) {
      return true;
    }
    return false;
  }

  Future<List<Order>> getOrderByDate(
      bool isUser, List<DateTime?>? listDate) async {
    if (isUser && await checkToken()) return [];
    final ref = _database.ref("order");
    List<Order> orders = [];
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (userId, userOrders) {
            Map<String, dynamic> userOrdersMap =
                Map<String, dynamic>.from(userOrders);
            userOrdersMap.forEach(
              (idOrder, dataOrder) {
                DateTime date =
                    DateFormat("HH:mm dd-MM-yyyy").parse(dataOrder["date"]);
                bool isCheck = checkInDay(date, listDate);
                if (isCheck) {
                  List<Cart> carts = (dataOrder["carts"] as List<dynamic>).map(
                    (e) {
                      return Cart(
                        idItem: e["idItem"],
                        quantity: e["quantity"],
                        totalPrice: e["totalPrice"],
                      );
                    },
                  ).toList();
                  final order = Order(
                      idOrder: idOrder,
                      date: dataOrder["date"],
                      carts: carts,
                      status: dataOrder["status"],
                      message: dataOrder["message"]);
                  orders.add(order);
                }
              },
            );
          },
        );
      }
      return orders;
    } catch (e) {
      print(e);
      return orders;
    }
  }

  Future<List<Order>> getOrderBySearch(bool isUser, String searchStr) async {
    if (isUser && await checkToken()) return [];
    final ref = _database.ref("order");
    List<Order> orders = [];
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (userId, userOrders) {
            Map<String, dynamic> userOrdersMap =
                Map<String, dynamic>.from(userOrders);
            userOrdersMap.forEach(
              (idOrder, dataOrder) {
                if (idOrder.contains(searchStr)) {
                  List<Cart> carts = (dataOrder["carts"] as List<dynamic>).map(
                    (e) {
                      return Cart(
                        idItem: e["idItem"],
                        quantity: e["quantity"],
                        totalPrice: e["totalPrice"],
                      );
                    },
                  ).toList();
                  final order = Order(
                      idOrder: idOrder,
                      date: dataOrder["date"],
                      carts: carts,
                      status: dataOrder["status"],
                      message: dataOrder["message"]);
                  orders.add(order);
                }
              },
            );
          },
        );
      }
      return orders;
    } catch (e) {
      print(e);
      return orders;
    }
  }

  Future<void> editOrderStatus(String idOrder, String date, List<Cart> carts,
      int status, String message) async {
    final ref = _database.ref("order");
    try {
      String idUser = "";
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (userId, userOrders) {
            Map<String, dynamic> userOrdersMap =
                Map<String, dynamic>.from(userOrders);
            userOrdersMap.forEach(
              (idOrder, dataOrder) {
                if (idOrder == idOrder) {
                  idUser = userId;
                }
              },
            );
          },
        );
        final reff = await _database.ref("order").child(idUser).child(idOrder);
        List<Map<String, dynamic>> dataCarts =
            carts.map((element) => element.ToJson()).toList();
        final dataEdit = {
          "date": date,
          "carts": dataCarts,
          "status": status,
          "message": message,
        };
        reff.set(dataEdit);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Order>> getAllOrders() async {
    List<Order> orders = [];
    final ref = _database.ref("order");
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (userId, userOrders) {
            Map<String, dynamic> userOrdersMap =
                Map<String, dynamic>.from(userOrders);

            userOrdersMap.forEach((orderId, orderData) {
              List<Cart> carts = (orderData["carts"] as List<dynamic>).map(
                (e) {
                  return Cart(
                    idItem: e["idItem"],
                    quantity: e["quantity"],
                    totalPrice: e["totalPrice"],
                  );
                },
              ).toList();
              final order = Order(
                idOrder: orderId,
                date: orderData["date"],
                carts: carts,
                status: orderData["status"],
                message: orderData["message"],
              );
              orders.add(order);
            });
          },
        );
      }
    } catch (e) {
      print("Error fetching all orders: $e");
    }
    return orders;
  }

  Future<void> deleteOrderById(String idUser, String idOrder) async {
    if (await checkToken()) return;
    final ref = _database.ref("order").child(idUser).child(idOrder);
    await ref.remove();
  }

  Future<void> deleteOrderAdminById(String idOrder) async {
    final ref = _database.ref("order");
    final snapshot = await ref.get();
    Map<String, dynamic> data =
        Map<String, dynamic>.from(snapshot.value as Map);
    data.forEach(
      (userId, userData) {
        Map<String, dynamic> dataOrder =
            Map<String, dynamic>.from(userData as Map);
        dataOrder.forEach(
          (orderId, orderData) async {
            if (orderId == idOrder) {
              await _database
                  .ref("order")
                  .child(userId)
                  .child(orderId)
                  .remove();
            }
          },
        );
      },
    );
  }

  Future<List<Order>> getOrdersUserBySearch(
      String idUser, String search) async {
    final ref = _database.ref("order").child(idUser);
    List<Order> orders = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach(
        (orderId, orderData) {
          List<Cart> carts = (orderData["carts"] as List<dynamic>).map(
            (e) {
              return Cart(
                idItem: e["idItem"],
                quantity: e["quantity"],
                totalPrice: e["totalPrice"],
              );
            },
          ).toList();
          final order = Order(
            idOrder: orderId,
            date: orderData["date"],
            carts: carts,
            status: orderData["status"],
            message: orderData["message"],
          );
          if (order.idOrder.contains(search)) {
            orders.add(order);
          }
        },
      );
    }
    return orders;
  }

  Future<List<Order>> getOrdersUserByStatus(String idUser, int status) async {
    if (await checkToken()) return [];
    final ref = _database.ref("order").child(idUser);
    List<Order> orders = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach(
        (orderId, orderData) {
          List<Cart> carts = (orderData["carts"] as List<dynamic>).map(
            (e) {
              return Cart(
                idItem: e["idItem"],
                quantity: e["quantity"],
                totalPrice: e["totalPrice"],
              );
            },
          ).toList();
          final order = Order(
            idOrder: orderId,
            date: orderData["date"],
            carts: carts,
            status: orderData["status"],
            message: orderData["message"],
          );
          if (order.status == status) {
            orders.add(order);
          }
        },
      );
    }
    return orders;
  }

  Future<List<Order>> getOrdersAdminByStatus(int status) async {
    final ref = _database.ref("order");
    List<Order> orders = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> dataUser =
          Map<String, dynamic>.from(snapshot.value as Map);
      dataUser.forEach(
        (userId, userData) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(userData as Map);
          data.forEach(
            (orderId, orderData) {
              List<Cart> carts = (orderData["carts"] as List<dynamic>).map(
                (e) {
                  return Cart(
                    idItem: e["idItem"],
                    quantity: e["quantity"],
                    totalPrice: e["totalPrice"],
                  );
                },
              ).toList();
              final order = Order(
                idOrder: orderId,
                date: orderData["date"],
                carts: carts,
                status: orderData["status"],
                message: orderData["message"],
              );
              if (order.status == status) {
                orders.add(order);
              }
            },
          );
        },
      );
    }
    return orders;
  }

  Future<List<Order>> getOrders(String idUser) async {
    if (await checkToken()) return [];
    final ref = _database.ref("order").child(idUser);
    List<Order> orders = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach(
        (orderId, orderData) {
          List<Cart> carts = (orderData["carts"] as List<dynamic>).map(
            (e) {
              return Cart(
                idItem: e["idItem"],
                quantity: e["quantity"],
                totalPrice: e["totalPrice"],
              );
            },
          ).toList();
          final order = Order(
            idOrder: orderId,
            date: orderData["date"],
            carts: carts,
            status: orderData["status"],
            message: orderData["message"],
          );
          orders.add(order);
        },
      );
    }
    return orders;
  }
}
