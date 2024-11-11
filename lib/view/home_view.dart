import 'dart:io';

import 'package:demo_firebase_realtime/controller/home_controller.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Obx(
                  () => controller.isItemsEmpty.value
                      ? const Center(
                          child: Text("You not items"),
                        )
                      : Visibility(
                          visible: controller.isLoading.value,
                          replacement: RefreshIndicator(
                            onRefresh: () => controller.getItemData(),
                            child: GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(16),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              children: List.generate(
                                controller.items.length,
                                (index) {
                                  Item item = controller.items[index];
                                  return CardWidget(
                                    controller: controller,
                                    item: item,
                                  );
                                },
                              ),
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'movePageAddItem',
        onPressed: () {
          Get.toNamed("/addEdit", arguments: {
            "page": "Add",
            "idUser": controller.user.getId,
          })!
              .then(
            (value) {
              controller.getItemData();
            },
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white.withOpacity(0.8),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.controller,
    required this.item,
  });
  final HomeController controller;
  final Item item;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "item${item.title}",
      onPressed: () {
        Get.toNamed("/detailItem", arguments: {
          "id": item.id,
          "title": item.title,
          "description": item.description,
          "price": item.price,
          "urlImage": item.urlImage,
        });
      },
      elevation: 10,
      splashColor: Colors.grey.shade400,
      backgroundColor: Colors.white.withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 18,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(
                  File(item.urlImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "${item.price} đ",
                style: const TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.deleteItem(item.id);
                    },
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ),
                FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/addEdit", arguments: {
                        "page": "Edit",
                        "idUser": controller.user.getId,
                        "id": item.id,
                        "title": item.title,
                        "description": item.description,
                        "price": item.price,
                        "urlImage": item.urlImage,
                      })?.then(
                        (value) {
                          controller.getItemData();
                        },
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
