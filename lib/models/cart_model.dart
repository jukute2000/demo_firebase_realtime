class Cart {
  final String idItem;
  int quantity;
  final int totalPrice;
  Cart(
      {required this.idItem, required this.quantity, required this.totalPrice});

  factory Cart.FormToJson(Map<String, dynamic> json) => Cart(
        idItem: json["idItem"],
        quantity: json["quantity"],
        totalPrice: json["totalPrice"],
      );

  Map<String, dynamic> ToJson() =>
      {"idItem": idItem, "quantity": quantity, "totalPrice": totalPrice};
}
