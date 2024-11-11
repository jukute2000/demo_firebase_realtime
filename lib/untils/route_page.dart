import 'package:demo_firebase_realtime/view/add_edit_item_view.dart';
import 'package:demo_firebase_realtime/view/detail_item_view.dart';
import 'package:demo_firebase_realtime/view/home_view.dart';
import 'package:get/get.dart';

getPage() => [
      GetPage(
        name: "/home",
        page: () => const HomeView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/addEdit",
        page: () => const AddEditItemView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/detailItem",
        page: () => DetailItemView(),
        fullscreenDialog: true,
      )
    ];
