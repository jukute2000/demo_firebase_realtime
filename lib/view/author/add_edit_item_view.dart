import 'dart:io';
import 'package:demo_firebase_realtime/controller/author/add_edit_item_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorAddEditItemView extends StatelessWidget {
  const AuthorAddEditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>? ?? {};
    final controller = Get.put(AuthorAddEditItemController(dataAgrument: data));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onSave(),
        shape: const CircleBorder(),
        backgroundColor: Colors.black.withOpacity(0.4),
        child: const Center(
          child: Icon(
            Icons.done,
            color: Colors.green,
          ),
        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Obx(
                            () => Container(
                              width: size.width,
                              height: size.width,
                              color: Colors.grey,
                              child: Stack(
                                children: [
                                  if (controller.imageUrl.value != "")
                                    SizedBox(
                                      width: size.width,
                                      height: size.width,
                                      child: controller.isPick
                                          ? Image.file(
                                              File(controller.imagePart!.path),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              controller.imageUrl.value,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  Align(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await controller.chooseImage();
                                      },
                                      child: const Icon(
                                        Icons.upload,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    const CircleBorder()),
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.black.withOpacity(0.2),
                                ),
                              ),
                              onPressed: () => Get.back(result: false),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: TextField(
                          controller: controller.price,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.red,
                          maxLength: 9,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.red),
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Price:",
                            hintStyle: TextStyle(color: Colors.red),
                            prefixText: "đ ",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: controller.title,
                          maxLines: 2,
                          maxLength: 100,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Title:",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Type product:",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Obx(
                          () => DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: controller.typeSelected.value,
                            hint: const Text("Type :"),
                            dropdownColor: Colors.white,
                            items: List.generate(
                              controller.typeData.length,
                              (index) => DropdownMenuItem(
                                value: index,
                                child: Text(
                                  controller.typeData[index].values.single,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.typeSelected.value = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Product description:",
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: controller.description,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              maxLength: 500,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Description:",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Status product:",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Obx(
                          () => DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: controller.status.value,
                            hint: const Text("Status :"),
                            dropdownColor: Colors.white,
                            items: List.generate(
                              2,
                              (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(controller.statusData[index]!)),
                            ),
                            onChanged: (value) {
                              controller.status.value = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
