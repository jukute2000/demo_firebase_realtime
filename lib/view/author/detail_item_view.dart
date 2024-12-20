import 'package:demo_firebase_realtime/controller/author/detail_item_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorDetailItemView extends StatelessWidget {
  const AuthorDetailItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(AuthorDetailItemController(data: data));
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : Stack(children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.width,
                        child: Image.network(
                          controller.urlImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${AppTheme.price(controller.price)} ",
                                          style: TextStyles.bold(
                                            16,
                                            Colors.red,
                                            TextDecoration.none,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "đ",
                                          style: TextStyles.bold(
                                            16,
                                            Colors.red,
                                            TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              controller.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.bold(
                                16,
                                Colors.black,
                                TextDecoration.none,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Type: ${controller.type!.nameType}",
                              style: TextStyles.medium(
                                14,
                                Colors.black,
                                TextDecoration.none,
                              ),
                            ),
                            const Divider(
                              height: 16,
                            ),
                            Text(
                              "Description :",
                              style: TextStyles.bold(
                                16,
                                Colors.black,
                                TextDecoration.none,
                              ),
                            ),
                            Text(
                              controller.description,
                              style: TextStyles.medium(
                                14,
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
              Align(
                alignment: const Alignment(-1, -0.9),
                child: FloatingActionButton(
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.black.withOpacity(0.3),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ])),
      bottomNavigationBar: bottomAppBarWidget(controller: controller),
    );
  }
}

class bottomAppBarWidget extends StatelessWidget {
  const bottomAppBarWidget({
    super.key,
    required this.controller,
  });

  final AuthorDetailItemController controller;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              heroTag: "addItemShopCart",
              shape: const Border(),
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.white,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Add to Cart",
                      style: TextStyles.medium(
                        14,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 6,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              heroTag: "buyItem",
              shape: const Border(),
              onPressed: () {},
              child: Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    TextSpan(
                      text: "Buy\n",
                      style: TextStyles.medium(
                        14,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: "${AppTheme.price(controller.price)} đ",
                      style: TextStyles.medium(
                        14,
                        Colors.white,
                        TextDecoration.none,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
