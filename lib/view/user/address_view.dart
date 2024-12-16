import 'package:demo_firebase_realtime/controller/user/address_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/address_model.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(AddressController(data: data));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: BackButton(
          onPressed: () => Get.back(result: true),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: AppTheme.padding16px,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery address:",
                              style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            controller.isAddressNull.value
                                ? const Center(
                                    child: Text(
                                      "User does not have saved delivery information",
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: controller.addresses!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Address addrress =
                                          controller.addresses![index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: AppTheme.padding8px,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            "${addrress.name} | ${addrress.phone}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          leading:
                                              !controller.isAddAddress.value
                                                  ? IconButton(
                                                      onPressed: () {
                                                        controller
                                                            .changeAddressChose(
                                                                addrress);
                                                      },
                                                      icon: Icon(
                                                        addrress.status == 0
                                                            ? Icons
                                                                .check_box_outline_blank
                                                            : Icons
                                                                .check_box_outlined,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                          subtitle: Text(
                                            addrress.address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing:
                                              !controller.isAddAddress.value
                                                  ? TextButton(
                                                      onPressed: () {
                                                        controller
                                                            .changeIsEditAddress(
                                                                addrress);
                                                      },
                                                      child: const Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                        ),
                                      );
                                    },
                                  ),
                            const Divider(),
                            !controller.isAddAddress.value
                                ? ElevatedButton(
                                    onPressed: () {
                                      controller.changeIsAddAddress();
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Add delivery address",
                                          style: TextStyle(
                                              color: AppTheme.textColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (controller.isAddAddress.value)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: AppTheme.padding16px,
                          width: size.width,
                          height: size.height * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    if (!controller.isEditAddress.value) {
                                      controller.changeIsAddAddress();
                                    } else {
                                      controller.changeIsEditAddress(null);
                                    }
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                              ),
                              Text(
                                controller.isEditAddress.value
                                    ? "Edit delivery address:"
                                    : "Add delivery address:",
                                style: const TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextEditWidget(
                                controller: controller.name,
                                labelText: "Recipient's name:",
                                textInputType: TextInputType.name,
                                isAdress: false,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextEditWidget(
                                controller: controller.numberPhone,
                                labelText: "Recipient's phone:",
                                textInputType: TextInputType.phone,
                                isAdress: false,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextEditWidget(
                                controller: controller.address,
                                labelText: "Recipient's address:",
                                textInputType: TextInputType.phone,
                                isAdress: true,
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              if (controller.isEditAddress.value)
                                SizedBox(
                                  width: size.width,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.deleteAddress();
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              if (controller.isEditAddress.value)
                                const SizedBox(
                                  height: 16,
                                ),
                              SizedBox(
                                width: size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (controller.isEditAddress.value) {
                                      controller.editAddress();
                                    } else {
                                      controller.addAddressUser();
                                    }
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}

class TextEditWidget extends StatelessWidget {
  const TextEditWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputType,
    required this.isAdress,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  final bool isAdress;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: Colors.black,
      maxLines: isAdress ? 2 : 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}