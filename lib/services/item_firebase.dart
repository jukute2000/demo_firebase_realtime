import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ItemFirebase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<Item>> fetchItems(String idUser) async {
    DatabaseReference ref = _database.ref("items").child(idUser);
    List<Item> items = [];
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach(
        (key, value) {
          Item item = Item.FromToJson(
            {
              "id": key,
              ...Map<String, dynamic>.from(value),
            },
          );
          items.add(item);
        },
      );
    }
    return items;
  }

  Future<void> deleteItem(String idUser, String id) async {
    await _database.ref("items").child(idUser).child(id).remove();
  }

  Future<bool> addItem(String idUser, String title, String description,
      int price, String urlImage) async {
    Map<String, dynamic> data = {
      "title": title,
      "description": description,
      "price": price,
      "urlImage": urlImage,
    };
    bool isTemp = false;
    await _database.ref("items").child(idUser).push().set(data).then(
      (value) {
        isTemp = true;
      },
    );
    return isTemp;
  }

  Future<bool> editItem(
    String idUser,
    String id,
    String title,
    String description,
    int price,
    String urlImage,
  ) async {
    bool isSuccess = false;
    Map<String, dynamic> data = {
      "title": title,
      "description": description,
      "price": price,
      "urlImage": urlImage,
    };
    await _database
        .ref("items")
        .child(idUser)
        .child(id)
        .set(data)
        .then((value) {
      isSuccess = true;
    });
    return isSuccess;
  }
}
