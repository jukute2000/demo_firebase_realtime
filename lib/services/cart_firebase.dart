import 'package:demo_firebase_realtime/models/cart_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class CartFirebase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Future<String> editItemCart({
    required String idUser,
    required String idItem,
    required int quantity,
    required int totalPrice,
  }) async {
    final data = {"quantity": quantity, "totalPrice": totalPrice};
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("carts").child(idUser).child(idItem);
      if (quantity == 0) {
        await ref.remove();
      } else {
        await ref.set(data);
      }
      return "success";
    } on FirebaseException catch (e) {
      return "${e.message}";
    }
  }

  Future<void> deleteItemCart(String idUser, String idItem) async {
    await FirebaseDatabase.instance
        .ref("carts")
        .child(idUser)
        .child(idItem)
        .remove();
  }

  Future<bool> addItemCart(
      {required String idUser,
      required String idItem,
      required int price}) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("carts").child(idUser).child(idItem);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final dataCart = Map<String, dynamic>.from(snapshot.value as Map);
        final data = {
          "quantity": dataCart["quantity"] + 1,
          "totalPrice": (dataCart["quantity"] + 1) * price,
        };
        await ref.update(data);
      } else {
        Map<String, dynamic> data = {
          "quantity": 1,
          "totalPrice": price,
        };
        await _database.ref("carts").child(idUser).child(idItem).set(data);
      }
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  Future<Cart?> getUserCartById(String idUser, String idItem) async {
    DatabaseReference ref = _database.ref("carts").child(idUser).child(idItem);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      Cart cart = Cart.FormToJson(
        {"idItem": idItem, ...Map<String, dynamic>.from(data)},
      );
      return cart;
    }
    return null;
  }

  Future<List<Cart>> getUserCart(String idUser) async {
    if (idUser == "") {
      return [];
    }
    DatabaseReference ref = _database.ref("carts").child(idUser);
    List<Cart> carts = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach(
        (key, value) {
          Cart cart = Cart.FormToJson({
            "idItem": key,
            ...Map<String, dynamic>.from(value),
          });
          carts.add(cart);
        },
      );
      return carts;
    }
    return carts;
  }
}
