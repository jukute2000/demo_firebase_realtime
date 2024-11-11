import 'package:get/get.dart';

class DetailItemController extends GetxController {
  final Map<String, dynamic> data;
  String id = "";
  String title = "";
  String description = "";
  int price = 0;
  String urlImage = "";

  DetailItemController({required this.data}) {
    id = data["id"];
    title = data["title"];
    description = data["description"];
    price = data["price"];
    urlImage = data["urlImage"];
  }
}
