import 'package:demo_firebase_realtime/controller/user/order_controller.dart';
import 'package:demo_firebase_realtime/models/cart_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Get.arguments as Map<String, String>;
    final controller = Get.put(OrderController(data: data));

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: BackButton(onPressed: () {
          Get.back(result: true);
        }),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: AppTheme.padding16px,
                    child: Container(
                      width: size.width,
                      padding: AppTheme.padding8px,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Order",
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Icon(Icons.location_on_outlined),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Container(
                                      padding: AppTheme.padding8px,
                                      width: size.width * (0.69),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Delivery address:",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          controller.isAddressNull.value
                                              ? const Text(
                                                  "User does not have saved delivery information",
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "${controller.address!.name}| ${controller.address!.phone}"),
                                                    Text(
                                                      controller
                                                          .address!.address,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.movePageAdress();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.grey,
                                        weight: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            padding: AppTheme.padding8px,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Products:",
                                  style: TextStyle(
                                    color: AppTheme.textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Obx(
                                  () => ListView.builder(
                                    itemCount: controller.items.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Cart? cart;
                                      if (controller.isCart) {
                                        cart = controller.carts[index];
                                      }
                                      final item = controller.items[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: Image.network(
                                              item.urlImage,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text(
                                              item.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Price : ${controller.isCart ? cart!.totalPrice : item.price}đ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                    "x ${controller.isCart ? cart!.quantity : 1}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          controller.isCart
                                              ? "Total price products(x${controller.totalQuantityProduct.toString()}): "
                                              : "Total price products: ",
                                          style: const TextStyle(
                                            color: AppTheme.textColor,
                                          ),
                                        ),
                                        Text(
                                            "${controller.isCart ? controller.totalPriceProduct.toString() : controller.items.first.price.toString()}đ")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            padding: AppTheme.padding8px,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Message for the shop:",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                  ),
                                ),
                                TextField(
                                  controller: controller.messageForShop,
                                  cursorColor: Colors.grey,
                                  maxLines: 5,
                                  maxLength: 300,
                                  decoration: const InputDecoration(
                                    hintText: "Message...",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.4,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.order();
                                  },
                                  child: const Text(
                                    "Order",
                                    style: TextStyle(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
