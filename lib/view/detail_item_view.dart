import 'dart:io';
import 'package:demo_firebase_realtime/controller/detail_item_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailItemView extends StatelessWidget {
  const DetailItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(DetailItemController(data: data));
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  height: size.width,
                  child: Image.file(
                    File(controller.urlImage),
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
                                    text: "đ",
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${controller.price}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              children: [
                                Text("Đã bán xxx"),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.heart_broken),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(controller.title),
                      const Divider(
                        height: 16,
                      ),
                      const Text("Mô tả sản phẩm :"),
                      Text(controller.description),
                      const Divider(
                        height: 16,
                      ),
                      const Text("Đánh Giá Sản Phẩm"),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "4.8/5",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "(99 đánh giá)",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
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
      ]),
      bottomNavigationBar: bottomAppBarWidget(controller: controller),
    );
  }
}

class bottomAppBarWidget extends StatelessWidget {
  const bottomAppBarWidget({
    super.key,
    required this.controller,
  });

  final DetailItemController controller;

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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.white,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Thêm vào Giỏ Hàng",
                      style: TextStyle(color: Colors.white),
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
              shape: Border(),
              onPressed: () {},
              child: Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    const TextSpan(
                      text: "Mua\n",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${controller.price} đ",
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 1,
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
