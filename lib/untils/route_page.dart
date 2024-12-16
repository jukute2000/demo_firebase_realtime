import 'package:demo_firebase_realtime/view/author/add_edit_item_view.dart';
import 'package:demo_firebase_realtime/view/author/detail_item_view.dart';
import 'package:demo_firebase_realtime/view/author/home_view.dart';
import 'package:demo_firebase_realtime/view/login_signup_view.dart';
import 'package:demo_firebase_realtime/view/user/address_view.dart';
import 'package:demo_firebase_realtime/view/user/phone_view.dart';
import 'package:demo_firebase_realtime/view/user/order_view.dart';
import 'package:demo_firebase_realtime/view/user/cart_view.dart';
import 'package:demo_firebase_realtime/view/user/detail_item_view.dart';
import 'package:demo_firebase_realtime/view/user/home_view.dart';
import 'package:demo_firebase_realtime/view/user/user_view.dart';
import 'package:get/get.dart';

getPage() => [
      GetPage(
        name: "/authorHome",
        page: () => const AuthHomeView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/userHome",
        page: () => const UserHomeView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/authorAddEdit",
        page: () => const AuthorAddEditItemView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/authorDetailItem",
        page: () => const AuthorDetailItemView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/userDetailItem",
        page: () => const UserDetailItemView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/loginSignup",
        page: () => const LoginSignupView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/cart",
        page: () => const CartView(),
        fullscreenDialog: true,
      ),
      GetPage(
        name: "/order",
        page: () => const OrderView(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/user",
        page: () => const UserView(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/phone",
        page: () => const PhoneView(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
      GetPage(
        name: "/address",
        page: () => const AddressView(),
        fullscreenDialog: true,
        preventDuplicates: false,
      ),
    ];
