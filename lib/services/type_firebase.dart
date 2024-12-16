import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:firebase_database/firebase_database.dart';

class TypeFirebase {
  final _database = FirebaseDatabase.instance;
  Future<TypeItem?> getTypeById(String idType) async {
    final ref = _database.ref("types").child(idType);
    TypeItem? type;
    try {
      final snapshot = await ref.get();
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      type = TypeItem.FromJson(
        {"idType": idType, ...Map<String, dynamic>.from(data)},
      );
    } catch (e) {
      print(e);
    }
    return type;
  }

  Future<List<TypeItem>> getAllType() async {
    final ref = _database.ref("types");
    List<TypeItem> types = [];
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((idType, dataType) {
          TypeItem type = TypeItem.FromJson({
            "idType": idType,
            ...Map<String, dynamic>.from(dataType),
          });
          types.add(type);
        });
      }
    } catch (e) {
      print(e);
    }
    return types;
  }

  Future<List<TypeItem>> getAllTypeOpen() async {
    final ref = _database.ref("types");
    List<TypeItem> types = [];
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((idType, dataType) {
          TypeItem type = TypeItem.FromJson({
            "idType": idType,
            ...Map<String, dynamic>.from(dataType),
          });
          if (type.status == 1) {
            types.add(type);
          }
        });
      }
    } catch (e) {
      print(e);
    }
    return types;
  }

  Future<void> addType(String type, int status) async {
    try {
      final data = {"nameType": type, "status": status};
      await _database.ref("types").push().set(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> editType(String idType, String type, int status) async {
    try {
      final data = {"nameType": type, "status": status};
      await _database.ref("types").child(idType).set(data);
    } catch (e) {
      print(e);
    }
  }
}
