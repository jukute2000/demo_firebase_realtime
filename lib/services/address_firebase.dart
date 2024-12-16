import 'package:firebase_database/firebase_database.dart';
import 'package:demo_firebase_realtime/models/address_model.dart';

class AddressFirebase {
  final _database = FirebaseDatabase.instance;

  Future<String> addAddressUser(
      String idUser, String name, String phone, String address) async {
    final data = {
      "name": name,
      "phone": phone,
      "address": address,
      "status": 0
    };
    try {
      await _database
          .ref("user")
          .child("addressUser")
          .child(idUser)
          .push()
          .set(data);
      return "Success";
    } on Exception catch (e) {
      return "$e";
    }
  }

  Future<Address?> getAddressStatus1(String idUser) async {
    final ref = _database.ref("user").child("addressUser").child(idUser);
    List<Address> addresses = [];
    try {
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (key, value) {
            Address address =
                Address.FormToJson({"idAddress": key, ...Map.from(value)});
            addresses.add(address);
          },
        );
        for (var element in addresses) {
          if (element.status == 1) {
            return element;
          }
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> deleteAddress(String idUser, String idAddress) async {
    bool isSuccess = false;
    await _database
        .ref("user")
        .child("addressUser")
        .child(idUser)
        .child(idAddress)
        .remove()
        .then(
          (value) => isSuccess = true,
        );
    return isSuccess;
  }

  Future<void> editAddress(String idUser, String idAddress, String name,
      String phone, String address, int status, bool isChangeStatus) async {
    if (isChangeStatus) status = status == 1 ? 0 : 1;
    final data = {
      "name": name,
      "phone": phone,
      "address": address,
      "status": status
    };

    await _database
        .ref("user")
        .child("addressUser")
        .child(idUser)
        .child(idAddress)
        .set(data);
  }

  Future<List<Address>?> getAddress(String idUser) async {
    final ref = _database.ref("user").child("addressUser").child(idUser);
    List<Address> addresses = [];
    try {
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach(
          (key, value) {
            Address address =
                Address.FormToJson({"idAddress": key, ...Map.from(value)});
            addresses.add(address);
          },
        );
        return addresses;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}
