import 'package:demo_firebase_realtime/models/cart_model.dart';

class Order {
  final String idOrder;
  final String date;
  final List<Cart> carts;
  final int status;
  final String message;
  Order({
    required this.date,
    required this.idOrder,
    required this.carts,
    required this.status,
    required this.message,
  });

  factory Order.FormToJson(Map<String, dynamic> json) => Order(
        idOrder: json["idOrder"],
        date: json["date"],
        carts: (json["carts"] as List).map((e) => Cart.FormToJson(e)).toList(),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "idOrder": idOrder,
        "date": date,
        "carts": carts.map((cart) => cart.ToJson()).toList(),
        "status": status,
        "message": message
      };
}
