import 'package:demo_firebase_realtime/controller/user/user_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.back(result: true);
          },
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: AppTheme.padding16px,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                    image: controller.user.image == ""
                                        ? const AssetImage(
                                            "assets/images/user-default.png",
                                          )
                                        : NetworkImage(
                                            controller.user.image,
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      controller.chooseImage();
                                    },
                                    icon: Icon(
                                      Icons.upload,
                                      size: size.width * 0.1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            flex: 24,
                            child: Container(
                              padding: AppTheme.padding16px,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 2),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _textButtonWidget(
                                    size: size,
                                    type: "Name",
                                    detailType: controller.textName,
                                    controller: controller,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _textButtonWidget(
                                    size: size,
                                    type: "Password",
                                    detailType: "****************",
                                    controller: controller,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _textButtonWidget(
                                    size: size,
                                    type: "Phone",
                                    detailType: controller.textPhone,
                                    controller: controller,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _addressButtonWidget(
                                    size: size,
                                    type: "Address",
                                    controller: controller,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            controller.logout();
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyles.bold(
                                  16,
                                  Colors.black,
                                  TextDecoration.none,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (controller.isSetUpName.value)
                        _editWidget(
                          controller: controller,
                          size: size,
                          child: Container(
                            padding: AppTheme.padding8px,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.isSetUpName.value =
                                        !controller.isSetUpName.value;
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: Text(
                                    "Change Name",
                                    style: TextStyles.bold(
                                      18,
                                      Colors.black,
                                      TextDecoration.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                _textFiledWidget(
                                  labelText: "Name",
                                  size: size,
                                  maxLength: 50,
                                  controller: controller,
                                  textController: controller.name,
                                  isPassword: false,
                                  textInputType: TextInputType.name,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        AppTheme.primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.changeName();
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyles.medium(
                                        14,
                                        Colors.black,
                                        TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (controller.isSetUpPassword.value)
                        _editWidget(
                          controller: controller,
                          size: size,
                          child: Container(
                            padding: AppTheme.padding8px,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.isSetUpPassword.value =
                                        !controller.isSetUpPassword.value;
                                    controller.curentPassword.clear();
                                    controller.newPassword.clear();
                                    controller.reNewpassword.clear();
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: Text(
                                    "Change Password",
                                    style: TextStyles.bold(
                                      18,
                                      Colors.black,
                                      TextDecoration.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                _textFiledWidget(
                                  labelText: "Curennt Password",
                                  size: size,
                                  controller: controller,
                                  maxLength: 18,
                                  textController: controller.curentPassword,
                                  isPassword: true,
                                  textInputType: TextInputType.visiblePassword,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                _textFiledWidget(
                                  labelText: "New Password",
                                  size: size,
                                  controller: controller,
                                  textController: controller.newPassword,
                                  maxLength: 18,
                                  isPassword: true,
                                  textInputType: TextInputType.visiblePassword,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                _textFiledWidget(
                                  labelText: "New Repeat Password",
                                  size: size,
                                  controller: controller,
                                  maxLength: 18,
                                  textController: controller.reNewpassword,
                                  isPassword: true,
                                  textInputType: TextInputType.visiblePassword,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        AppTheme.primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.changePassword();
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyles.medium(
                                        14,
                                        Colors.black,
                                        TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _editWidget extends StatelessWidget {
  const _editWidget({
    required this.controller,
    required this.size,
    required this.child,
  });

  final UserController controller;
  final Size size;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _textFiledWidget extends StatelessWidget {
  const _textFiledWidget({
    required this.labelText,
    required this.size,
    required this.textController,
    required this.controller,
    required this.isPassword,
    required this.maxLength,
    required this.textInputType,
  });

  final Size size;
  final TextEditingController textController;
  final UserController controller;
  final TextInputType textInputType;
  final String labelText;
  final bool isPassword;
  final int maxLength;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: TextField(
        controller: textController,
        maxLines: 1,
        cursorColor: Colors.grey,
        keyboardType: textInputType,
        maxLength: maxLength,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _textButtonWidget extends StatelessWidget {
  const _textButtonWidget({
    required this.type,
    required this.detailType,
    required this.size,
    required this.controller,
  });
  final String type;
  final String detailType;
  final Size size;
  final UserController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: AppTheme.padding8px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black54,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 14,
            child: Text(
              "$type: $detailType",
              overflow: TextOverflow.ellipsis,
              style: TextStyles.medium(
                14,
                Colors.black,
                TextDecoration.none,
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.chooseSetUp(type);
                },
                icon: Row(
                  children: [
                    Text(
                      "Set up now",
                      style: TextStyles.medium(
                        16,
                        Colors.green,
                        TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _addressButtonWidget extends StatelessWidget {
  const _addressButtonWidget({
    required this.type,
    required this.size,
    required this.controller,
  });
  final String type;
  final Size size;
  final UserController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: AppTheme.padding8px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black54,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$type:",
                  style: TextStyles.medium(
                    14,
                    Colors.black,
                    TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                controller.isAddressNull.value
                    ? const SizedBox()
                    : Container(
                        padding: AppTheme.padding8px,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.address?.name} | ${controller.address?.phone}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium(
                                14,
                                Colors.black,
                                TextDecoration.none,
                              ),
                            ),
                            Text(
                              controller.address?.address ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.light(
                                14,
                                Colors.black,
                                TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.chooseSetUp(type);
                },
                icon: Row(
                  children: [
                    Text(
                      "Set up now",
                      style: TextStyles.medium(
                        14,
                        Colors.green,
                        TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
