import 'package:demo_firebase_realtime/controller/add_edit_item_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditItemView extends StatelessWidget {
  const AddEditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final dataAgrument = Get.arguments as Map<String, dynamic>;
    AddEditItemController controller =
        Get.put(AddEditItemController(dataAgrument: dataAgrument));
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: Text(controller.isPageAdd ? "ADD ITEM" : "EDIT ITEM"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFieldWidget(
                    controller: controller.title,
                    isEnabled: true,
                    textInputType: TextInputType.text,
                    labalText: "Title:",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFieldWidget(
                    controller: controller.description,
                    isEnabled: true,
                    textInputType: TextInputType.text,
                    labalText: "Description:",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: TextFieldWidget(
                          controller: controller.urlImage,
                          textInputType: TextInputType.text,
                          labalText: "Url image:",
                          isEnabled: false,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: size.width * 0.2,
                        child: FloatingActionButton(
                          heroTag: "Upload Image",
                          elevation: 10,
                          splashColor: Colors.grey.shade400,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          onPressed: () async {
                            await controller.chooseImage();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_download,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Image",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFieldWidget(
                    controller: controller.price,
                    isEnabled: true,
                    textInputType: TextInputType.number,
                    labalText: "Price:",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      width: size.width * 0.6,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        splashColor: Colors.grey.shade400,
                        onPressed: () async {
                          await controller.onSave();
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.labalText,
    required this.isEnabled,
  });
  final TextEditingController controller;
  final TextInputType textInputType;
  final String labalText;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: labalText,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
