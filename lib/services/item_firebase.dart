import 'dart:io';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/services/imagur_service.dart';
import 'package:firebase_database/firebase_database.dart';

class ItemFirebase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<Item>> fetchItems(bool isUser) async {
    DatabaseReference ref = _database.ref("items");
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
          if (isUser) {
            if (item.status == 1) {
              items.add(item);
            }
          } else {
            items.add(item);
          }
        },
      );
    }
    return items;
  }

  Future<List<Item>> getItemsByIdtype(bool isUser, String idType) async {
    DatabaseReference ref = _database.ref("items");
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
          if (isUser) {
            if (item.status == 1 && item.idType == idType) {
              items.add(item);
            }
          } else if (item.idType == idType) {
            items.add(item);
          }
        },
      );
    }
    return items;
  }

  Future<List<Item>> getItemsBySearch(bool isUser, String searchStr) async {
    DatabaseReference ref = _database.ref("items");
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
          if (isUser) {
            if (item.status == 1 && item.title.contains(searchStr)) {
              items.add(item);
            }
          } else if (item.title.contains(searchStr)) {
            items.add(item);
          }
        },
      );
    }
    return items;
  }

  Future<Item?> getItemById(String idItem) async {
    try {
      DatabaseReference ref = _database.ref("items").child(idItem);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        Item item =
            Item.FromToJson({"id": idItem, ...Map<String, dynamic>.from(data)});
        return item;
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> deleteItem(String id, String tagImage) async {
    try {
      await _database.ref("items").child(id).remove();
      await ImagurService.deleteImage(tagImage);
      return true;
    } catch (e) {
      print("Failed delete item :e");
    }
    return false;
  }

  Future<bool> addItem(
      {required String title,
      required String idType,
      required String description,
      required int price,
      required File imageFile,
      required int status}) async {
    bool isTemp = false;
    List<String> image = await ImagurService.uploadImage(imageFile);
    if (image.isNotEmpty) {
      Map<String, dynamic> data = {
        "title": title,
        "idType": idType,
        "description": description,
        "price": price,
        "urlImage": image[0],
        "tagImage": image[1],
        "status": status,
      };
      await _database.ref("items").push().set(data).then(
        (value) {
          isTemp = true;
        },
      );
    }
    return isTemp;
  }

  Future<bool> editItem(
      {required String id,
      required String title,
      required String idType,
      required String description,
      required int price,
      required File imageFile,
      required int status}) async {
    bool isSuccess = false;
    List<String> urlImage = await ImagurService.uploadImage(imageFile);
    if (urlImage.isNotEmpty) {
      Map<String, dynamic> data = {
        "title": title,
        "idType": idType,
        "description": description,
        "price": price,
        "urlImage": urlImage[0],
        "tagImage": urlImage[1],
        "status": status,
      };
      await _database.ref("items").child(id).set(data).then((value) {
        isSuccess = true;
      });
    }
    return isSuccess;
  }

  Future<bool> editItemNotPick(
      {required String id,
      required String title,
      required String idType,
      required String description,
      required int price,
      required String urlImage,
      required String tagImage,
      required int status}) async {
    bool isSuccess = false;
    Map<String, dynamic> data = {
      "title": title,
      "idType": idType,
      "description": description,
      "price": price,
      "urlImage": urlImage,
      "tagImage": tagImage,
      "status": status,
    };
    await _database.ref("items").child(id).set(data).then((value) {
      isSuccess = true;
    });

    return isSuccess;
  }
}
