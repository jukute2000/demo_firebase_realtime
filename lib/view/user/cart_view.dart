import 'package:demo_firebase_realtime/controller/user/cart_controller.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(CartController(data: data));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: Obx(
          () => !controller.isChoose.value
              ? BackButton(
                  onPressed: () => Get.back(),
                )
              : const SizedBox(),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => controller.chooseCart(),
              icon: Icon(
                controller.isChoose.value
                    ? Icons.disabled_by_default_outlined
                    : Icons.check_box_outlined,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.isChoose.value
            ? FloatingActionButton(
                heroTag: "buyProducts",
                backgroundColor: Colors.black.withOpacity(0.1),
                shape: const CircleBorder(),
                onPressed: () async {
                  controller.buyCarts();
                },
                child: const Center(
                  child: Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.black,
                  ),
                ),
              )
            : const SizedBox(),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : SafeArea(
                child: controller.quantityItems.isEmpty
                    ? Center(
                        child: Text(
                          "There are no items in your cart.",
                          style: TextStyles.bold(
                            18,
                            Colors.black,
                            TextDecoration.none,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.carts.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          Item item = controller.itemsCart[index];
                          return Obx(
                            () => Container(
                              margin: const EdgeInsets.all(16),
                              width: size.width,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: size.width,
                                    height: size.height * 0.2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                width: size.width * 0.4,
                                                child: Image.network(
                                                  item.urlImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            if (controller.isChoose.value)
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  height: size.width * 0.05,
                                                  width: size.width * 0.05,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: FloatingActionButton(
                                                      backgroundColor:
                                                          Colors.white,
                                                      onPressed: () {
                                                        controller.chooseItem[
                                                                item.id] =
                                                            !controller
                                                                    .chooseItem[
                                                                item.id]!;
                                                      },
                                                      child: controller
                                                                  .chooseItem[
                                                              item.id]!
                                                          ? Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green,
                                                              size: size.width *
                                                                  0.1,
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        Column(
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: SizedBox(
                                                width: size.width * 0.35,
                                                child: Text(
                                                  item.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyles.bold(
                                                    16,
                                                    Colors.black,
                                                    TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: SizedBox(
                                                width: size.width * 0.35,
                                                child: Text(
                                                  "Type: ${controller.listTypeProduct[index]}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyles.medium(
                                                    14,
                                                    Colors.grey,
                                                    TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: SizedBox(
                                                width: size.width * 0.35,
                                                child: Text(
                                                  "Unit price: ${AppTheme.price(item.price)} đ",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyles.medium(
                                                    14,
                                                    Colors.grey,
                                                    TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Total price : ${AppTheme.price(controller.totalPriceItems[index])} đ",
                                            style: TextStyles.medium(
                                              14,
                                              Colors.black,
                                              TextDecoration.none,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: controller
                                                        .isSelectEdit[index]
                                                    ? () {
                                                        controller
                                                            .addRemoveQuantity(
                                                                index, false);
                                                      }
                                                    : null,
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(
                                                controller.quantityItems[index]
                                                    .toString(),
                                                style: TextStyles.medium(
                                                  14,
                                                  Colors.black,
                                                  TextDecoration.none,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: controller
                                                        .isSelectEdit[index]
                                                    ? () {
                                                        controller
                                                            .addRemoveQuantity(
                                                                index, true);
                                                      }
                                                    : null,
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!controller.isChoose.value)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.3,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      controller.isSelectEdit[
                                                              index]
                                                          ? Colors.red.shade300
                                                          : Colors
                                                              .yellow.shade300),
                                            ),
                                            onPressed: () {
                                              if (controller
                                                  .isSelectEdit[index]) {
                                                controller.cancelEdit(index);
                                              }
                                              controller
                                                  .changeIsSelectEdit(index);
                                            },
                                            child: Text(
                                              controller.isSelectEdit[index]
                                                  ? "Cancel"
                                                  : "Edit",
                                              style: TextStyles.medium(
                                                14,
                                                Colors.black,
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.3,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.green.shade300),
                                            ),
                                            onPressed: controller
                                                    .isSelectEdit[index]
                                                ? () async {
                                                    if (controller
                                                        .isSelectEdit[index]) {
                                                      await controller
                                                          .submitEditItems(
                                                              index);
                                                    }
                                                    controller
                                                        .changeIsSelectEdit(
                                                            index);
                                                  }
                                                : () {
                                                    controller.buyCart(item.id);
                                                  },
                                            child: Text(
                                              controller.isSelectEdit[index]
                                                  ? "Yes"
                                                  : "Buy",
                                              style: TextStyles.medium(
                                                14,
                                                Colors.black,
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
