import 'package:demo_firebase_realtime/controller/user/phone_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneView extends StatelessWidget {
  const PhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(PhoneController());
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Get.back(result: false),
        ),
        backgroundColor: AppTheme.primaryColor,
        title: const Text("Phone"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: size.width,
              margin: AppTheme.padding16px,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: const AssetImage(
                    "assets/images/football.jpg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  )
                : SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: AppTheme.padding16px,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.55,
                                    child: TextField(
                                      controller: controller.phone,
                                      keyboardType: TextInputType.phone,
                                      cursorColor: Colors.black,
                                      maxLength: 12,
                                      decoration: InputDecoration(
                                        labelText: "Phone",
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: FloatingActionButton(
                                      heroTag: "Receive OTP",
                                      backgroundColor: Colors.white,
                                      onPressed: () async {
                                        await controller.receiveOTP();
                                      },
                                      child: const Text(
                                        "Receive OTP",
                                        style: TextStyle(
                                            color: AppTheme.textColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                child: TextField(
                                  controller: controller.otp,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "OTP",
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: AppTheme.textColor),
                                  ),
                                  onPressed: () {
                                    controller.updatePhone();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
