import 'package:demo_firebase_realtime/controller/user/home_controller.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/auth_model.dart';
import '../../models/cart_model.dart';
import '../../models/type_item_model.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    UserHomeController controller = Get.put(UserHomeController());
    final size = MediaQuery.of(context).size;
    List<Widget> _bodyWidget = [
      _home(controller: controller, size: size),
      _order(controller: controller, size: size),
    ];
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      floatingActionButton: Obx(
        () => controller.isLoading.value
            ? const SizedBox()
            : FloatingActionButton(
                heroTag: "cart",
                shape: const CircleBorder(),
                backgroundColor: Colors.black.withOpacity(0.4),
                onPressed: () {
                  Get.toNamed("/cart",
                      arguments: {"idUser": controller.user.getId});
                },
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
      ),
      appBar: AppBar(
        surfaceTintColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        leading: Obx(
          () => controller.isLoading.value
              ? const SizedBox()
              : Container(
                  margin: AppTheme.padding8px,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: controller.user.image != ""
                          ? NetworkImage(
                              controller.user.image,
                            )
                          : const AssetImage("assets/images/user-default.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        controller.moveUser();
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
        ),
        actions: [
          Obx(
            () => controller.pageSelect.value == 0
                ? controller.isLoading.value
                    ? const SizedBox()
                    : PopupMenuButton(
                        onSelected: (value) {
                          controller.getItemDataByIdType(value);
                        },
                        color: Colors.white,
                        icon: Image(
                          image: const AssetImage("assets/images/arrange.png"),
                          fit: BoxFit.cover,
                          height: size.width * 0.06,
                          width: size.width * 0.06,
                        ),
                        itemBuilder: (context) => List.generate(
                          controller.typesAll.length,
                          (index) {
                            TypeItem type = controller.typesAll[index];
                            return PopupMenuItem(
                              value: type.idType,
                              child: ListTile(
                                title: Text(
                                  type.nameType,
                                  style: TextStyles.medium(
                                    14,
                                    Colors.black,
                                    TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                : controller.isLoading.value
                    ? const SizedBox()
                    : PopupMenuButton(
                        onSelected: (value) {
                          controller.getDataOrdersByStatus(value: value);
                        },
                        color: Colors.white,
                        icon: Image(
                          image: const AssetImage("assets/images/arrange.png"),
                          fit: BoxFit.cover,
                          height: size.width * 0.06,
                          width: size.width * 0.06,
                        ),
                        itemBuilder: (context) => List.generate(
                          controller.statusOrderData.length,
                          (index) {
                            return PopupMenuItem(
                              value: index,
                              child: ListTile(
                                title: Text(
                                  controller.statusOrderData[index].toString(),
                                  style: TextStyles.medium(
                                    14,
                                    Colors.black,
                                    TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : SafeArea(child: _bodyWidget[controller.pageSelect.value]),
      ),
      bottomNavigationBar: Obx(
        () => controller.isLoading.value
            ? const SizedBox()
            : _bottomNavigationBar(controller: controller),
      ),
    );
  }
}

class _order extends StatelessWidget {
  const _order({
    super.key,
    required this.controller,
    required this.size,
  });
  final UserHomeController controller;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.isLoading.value,
      replacement: RefreshIndicator(
        onRefresh: () => controller.getDataOrders(),
        child: Obx(
          () => controller.isOrdersNull.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Non orders",
                        style: TextStyles.bold(
                          16,
                          Colors.black,
                          TextDecoration.none,
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          controller.getDataOrders();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: size.width,
                            child: TextField(
                              cursorColor: Colors.green,
                              controller: controller.searchOrder,
                              decoration: InputDecoration(
                                labelText: "Search",
                                labelStyle: TextStyles.medium(
                                  14,
                                  Colors.black,
                                  TextDecoration.none,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    await controller.getDataOrdersBySearch();
                                  },
                                  icon: const Icon(Icons.search,
                                      color: Colors.black),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await controller.getOrderByDate(
                              context,
                              size.width * 0.8,
                              size.width * 0.8,
                            );
                          },
                          icon: const Icon(
                            Icons.date_range,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: controller.orders!.length,
                          itemBuilder: (context, indexOrder) {
                            int totalAllPrice = 0;
                            int totalAllProduct = 0;
                            return FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                width: size.width,
                                height: size.height * 0.45,
                                padding: AppTheme.padding16px,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Order information",
                                        style: TextStyles.bold(
                                          18,
                                          Colors.black,
                                          TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Id order:",
                                            style: TextStyles.bold(
                                              16,
                                              Colors.black,
                                              TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${controller.orders![indexOrder].idOrder}",
                                            style: TextStyles.light(
                                              16,
                                              Colors.black,
                                              TextDecoration.none,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Date:",
                                            style: TextStyles.bold(
                                              16,
                                              Colors.black,
                                              TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${controller.orders![indexOrder].date}",
                                            style: TextStyles.light(
                                              16,
                                              Colors.black,
                                              TextDecoration.none,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Products:",
                                      style: TextStyles.bold(
                                        16,
                                        Colors.black,
                                        TextDecoration.underline,
                                      ),
                                    ),
                                    const Divider(
                                      height: 16,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          controller
                                              .orders![indexOrder].carts.length,
                                          (indexCart) {
                                            Cart cart = controller
                                                .orders![indexOrder]
                                                .carts[indexCart];
                                            Item item =
                                                controller.itemOrder[indexOrder]
                                                    [indexCart];
                                            totalAllProduct += cart.quantity;
                                            totalAllPrice += cart.totalPrice;
                                            return SizedBox(
                                              height: size.height * 0.15,
                                              width: size.width * 0.8,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.35,
                                                    height: size.height * 0.15,
                                                    child: Image.network(
                                                      item.urlImage,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.42,
                                                    height: size.height * 0.15,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.title,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              TextStyles.black(
                                                            16,
                                                            Colors.black,
                                                            TextDecoration.none,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              "x ${cart.quantity}",
                                                              style: TextStyles
                                                                  .bold(
                                                                14,
                                                                Colors.grey,
                                                                TextDecoration
                                                                    .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(
                                                            "Total price : ${AppTheme.price(cart.totalPrice)}đ",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                TextStyles.bold(
                                                              14,
                                                              Colors.grey,
                                                              TextDecoration
                                                                  .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "Total price all product( $totalAllProduct): ${AppTheme.price(totalAllPrice)} đ",
                                        style: TextStyles.bold(
                                          16,
                                          Colors.black,
                                          TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text.rich(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Message for shop:",
                                              style: TextStyles.bold(
                                                16,
                                                Colors.black,
                                                TextDecoration.underline,
                                              ),
                                            ),
                                            TextSpan(
                                              text: controller
                                                          .orders![indexOrder]
                                                          .message ==
                                                      ""
                                                  ? " Non message for shop"
                                                  : " ${controller.orders![indexOrder].message}",
                                              style: TextStyles.light(
                                                16,
                                                Colors.black,
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "Order status : ${controller.statusOrders[indexOrder]}",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: controller
                                                        .orders![indexOrder]
                                                        .status ==
                                                    1
                                                ? Colors.green
                                                : Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _bottomNavigationBar extends StatelessWidget {
  const _bottomNavigationBar({
    super.key,
    required this.controller,
  });

  final UserHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        currentIndex: controller.pageSelect.value,
        onTap: (value) {
          controller.choosePage(value);
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: "Order",
          ),
        ],
      ),
    );
  }
}

class _home extends StatelessWidget {
  const _home({
    super.key,
    required this.controller,
    required this.size,
  });

  final UserHomeController controller;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.isLoading.value,
      replacement: RefreshIndicator(
          onRefresh: () => controller.getDataItems(),
          child: controller.isItemEmpty.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Non products",
                        style: TextStyles.black(
                            18, Colors.black, TextDecoration.none),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          controller.getDataItems();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: size.width,
                      child: TextField(
                        cursorColor: Colors.green,
                        controller: controller.searchItem,
                        decoration: InputDecoration(
                          labelText: "Search",
                          labelStyle: TextStyles.medium(
                            16,
                            Colors.black,
                            TextDecoration.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.getDataItemsBySearch();
                            },
                            icon: const Icon(Icons.search, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        padding: const EdgeInsets.all(16),
                        children: List.generate(
                          controller.items.length,
                          (index) {
                            Item item = controller.items[index];
                            return _productWidget(
                              item: item,
                              user: controller.user,
                              type: controller.types[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _productWidget extends StatelessWidget {
  const _productWidget({
    super.key,
    required this.item,
    required this.user,
    required this.type,
  });

  final Item item;
  final Auth user;
  final String type;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      heroTag: "item${item.id}",
      splashColor: Colors.grey,
      onPressed: () {
        Get.toNamed(
          "/userDetailItem",
          arguments: {
            "idUser": user.getId,
            "idItem": item.id,
            "urlImage": item.urlImage,
            "tagImage": item.tagImage,
            "price": item.price,
            "title": item.title,
            "decription": item.description,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 16,
              child: Container(
                padding: AppTheme.padding8px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  item.urlImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppTheme.price(item.price)} đ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(14, Colors.red, TextDecoration.none),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyles.bold(14, Colors.black, TextDecoration.none),
              ),
            ),
            const Spacer(),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                child: Text(
                  "Type : $type",
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyles.medium(14, Colors.black, TextDecoration.none),
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
