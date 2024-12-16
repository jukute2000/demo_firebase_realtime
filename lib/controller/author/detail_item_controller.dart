import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:demo_firebase_realtime/services/type_firebase.dart';
import 'package:get/get.dart';

class AuthorDetailItemController extends GetxController {
  final Map<String, dynamic> data;
  final _typeFirebase = TypeFirebase();
  RxBool isLoading = true.obs;
  TypeItem? type;
  String id = "";
  String idType = "";
  String title = "";
  String description = "";
  int price = 0;
  String urlImage = "";
  int status = 0;

  AuthorDetailItemController({required this.data}) {
    id = data["id"];
    idType = data["idType"];
    title = data["title"];
    description = data["description"];
    price = data["price"];
    urlImage = data["urlImage"];
    status = data["status"];
    getTypeProduct();
  }

  Future<void> getTypeProduct() async {
    isLoading.value = true;
    type = await _typeFirebase.getTypeById(idType);
    isLoading.value = false;
  }
}
