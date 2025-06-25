import 'package:demo_firebase_realtime/controller/user/order_controller.dart';
import 'package:demo_firebase_realtime/models/cart_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late Map<String, String> data;
  late OrderController controller;
  @override
  void initState() {
    super.initState();
    data = Get.arguments as Map<String, String>;
    controller = Get.put(OrderController(data: data));
  }

  @override
  void dispose() {
    controller.dispose();
    data.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                            Center(
                              child: Text(
                                "Order",
                                style: TextStyles.bold(
                                  18,
                                  Colors.black,
                                  TextDecoration.none,
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
                                            Text(
                                              "Delivery address:",
                                              style: TextStyles.medium(
                                                16,
                                                Colors.black,
                                                TextDecoration.underline,
                                              ),
                                            ),
                                            controller.isAddressNull.value
                                                ? Text(
                                                    "User does not have saved delivery information",
                                                    style: TextStyles.medium(
                                                      16,
                                                      Colors.black,
                                                      TextDecoration.none,
                                                    ),
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${controller.address!.name}| ${controller.address!.phone}",
                                                        style: TextStyles.light(
                                                          14,
                                                          Colors.black,
                                                          TextDecoration.none,
                                                        ),
                                                      ),
                                                      Text(
                                                        controller
                                                            .address!.address,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyles.light(
                                                          14,
                                                          Colors.black,
                                                          TextDecoration.none,
                                                        ),
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
                                  Text(
                                    "Products:",
                                    style: TextStyles.medium(
                                      16,
                                      Colors.black,
                                      TextDecoration.underline,
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
                                                style: TextStyles.medium(
                                                  16,
                                                  Colors.black,
                                                  TextDecoration.none,
                                                ),
                                              ),
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Total Price: ${controller.isCart ? AppTheme.price(cart!.totalPrice) : AppTheme.price(item.price)} đ",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyles.medium(
                                                      14,
                                                      Colors.grey,
                                                      TextDecoration.none,
                                                    ),
                                                  ),
                                                  Text(
                                                    "x ${controller.isCart ? cart!.quantity : 1}",
                                                    style: TextStyles.medium(
                                                      14,
                                                      Colors.grey,
                                                      TextDecoration.none,
                                                    ),
                                                  ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            controller.isCart
                                                ? "Total price products(x${controller.totalQuantityProduct}): "
                                                : "Total price products: ",
                                            style: TextStyles.medium(
                                              16,
                                              Colors.black,
                                              TextDecoration.none,
                                            ),
                                          ),
                                          Text(
                                            "${controller.isCart ? AppTheme.price(controller.totalPriceProduct) : AppTheme.price(controller.items.first.price)} đ",
                                            style: TextStyles.medium(
                                              16,
                                              Colors.black,
                                              TextDecoration.none,
                                            ),
                                          ),
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
                                  Text(
                                    "Message for the shop:",
                                    style: TextStyles.medium(
                                      16,
                                      Colors.black,
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextField(
                                    controller: controller.messageForShop,
                                    focusNode:
                                        controller.focusNodeMessageForShop,
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
                                    child: Text(
                                      "Order",
                                      style: TextStyles.medium(
                                        14,
                                        Colors.black,
                                        TextDecoration.none,
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
      ),
    );
  }
}
