import 'package:demo_firebase_realtime/models/auth_model.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:demo_firebase_realtime/services/item_firebase.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ItemFirebase _itemFirebase = ItemFirebase();
  List<Item> items = [];
  RxBool isItemsEmpty = true.obs;
  RxBool isLoading = true.obs;
  late Auth user;

  Future<void> deleteItem(String id) async {
    isLoading.value = true;
    await _itemFirebase.deleteItem(user.getId!, id);
    await getItemData();
    isLoading.value = false;
  }

  Future<void> getItemData() async {
    isLoading.value = true;
    items = await _itemFirebase.fetchItems(user.getId!);
    isItemsEmpty.value = items.isEmpty;
    isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    AuthFirebase auth = AuthFirebase();
    user = await auth.getUser();
    getItemData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
