import 'package:demo_firebase_realtime/controller/user/detail_item_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailItemView extends StatelessWidget {
  const UserDetailItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(DetailItemController(data));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.width,
                    child: Image.network(
                      controller.urlImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ButtonStyle(
                        shape: const WidgetStatePropertyAll(CircleBorder()),
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.black.withOpacity(0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${AppTheme.price(controller.price)} đ",
                      style: TextStyles.bold(
                        18,
                        Colors.red,
                        TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      controller.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold(
                        18,
                        Colors.black,
                        TextDecoration.none,
                      ),
                    ),
                    const Divider(
                      height: 16,
                    ),
                    Text(
                      "Decription :",
                      style: TextStyles.medium(
                        16,
                        Colors.black,
                        TextDecoration.none,
                      ),
                    ),
                    Text(
                      controller.description,
                      style: TextStyles.light(
                        16,
                        Colors.black,
                        TextDecoration.none,
                      ),
                    ),
                    const Divider(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: size.width * 0.4,
              child: FloatingActionButton(
                heroTag: "addToCart${controller.title}",
                onPressed: () {
                  controller.addItemCart();
                },
                shape: InputBorder.none,
                backgroundColor: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.white,
                    ),
                    Text(
                      "Add to cart",
                      style: TextStyles.medium(
                        16,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.6,
              child: FloatingActionButton(
                heroTag: "buy${controller.title}",
                onPressed: () {
                  controller.getDiablog();
                },
                shape: InputBorder.none,
                backgroundColor: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Buy",
                      style: TextStyles.medium(
                        16,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    ),
                    Text(
                      "${AppTheme.price(controller.price)} đ",
                      style: TextStyles.medium(
                        16,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
