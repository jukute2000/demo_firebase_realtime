import 'package:demo_firebase_realtime/controller/login_signup_controller.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginSignupView extends StatelessWidget {
  const LoginSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginSignupController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: Obx(
          () => !controller.isPageLogin.value
              ? BackButton(
                  onPressed: () {
                    controller.changePageAddEdit();
                  },
                )
              : Container(),
        ),
        title: Obx(
          () => Text(
            controller.isPageLogin.value ? "LOGIN" : "SIGNUP",
            style: TextStyles.bold(
              18,
              Colors.black,
              TextDecoration.none,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _backgroundWidget(size: size),
          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: controller.gmail,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email_outlined),
                                  label: Text(
                                    "Gmail:",
                                    style: TextStyles.medium(
                                      14,
                                      Colors.black,
                                      TextDecoration.none,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (!controller.isPageLogin.value)
                              const SizedBox(
                                height: 16,
                              ),
                            if (!controller.isPageLogin.value)
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: controller.username,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    label: Text(
                                      "User Name:",
                                      style: TextStyles.medium(
                                        14,
                                        Colors.black,
                                        TextDecoration.none,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Obx(
                                () => TextField(
                                  controller: controller.password,
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: Colors.grey,
                                  obscureText: controller.isOpcusPassword.value,
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.password_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        controller.isOpcusPassword.value =
                                            !controller.isOpcusPassword.value;
                                      },
                                      icon: Icon(
                                          controller.isOpcusPassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility_sharp),
                                    ),
                                    label: Text(
                                      "Passwoord:",
                                      style: TextStyles.medium(
                                        14,
                                        Colors.black,
                                        TextDecoration.none,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            if (!controller.isPageLogin.value)
                              const SizedBox(
                                height: 16,
                              ),
                            if (!controller.isPageLogin.value)
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Obx(
                                  () => TextField(
                                    controller: controller.rePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor: Colors.grey,
                                    obscureText:
                                        controller.isOpcusRePassword.value,
                                    decoration: InputDecoration(
                                      icon: const Icon(Icons.password_outlined),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.isOpcusRePassword.value =
                                              !controller
                                                  .isOpcusRePassword.value;
                                        },
                                        icon: Icon(
                                            controller.isOpcusRePassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility_sharp),
                                      ),
                                      label: Text(
                                        "Re-Passwoord:",
                                        style: TextStyles.medium(
                                          14,
                                          Colors.black,
                                          TextDecoration.none,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (!controller.isPageLogin.value)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "I have read the ",
                                          style: TextStyles.medium(
                                            14,
                                            Colors.black,
                                            TextDecoration.none,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Privace Policy",
                                          style: TextStyles.medium(
                                            14,
                                            Colors.black,
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.isPolicy.value =
                                          !controller.isPolicy.value;
                                    },
                                    child: Container(
                                      width: size.width / 20,
                                      height: size.width / 20,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: Colors.grey.shade600,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: controller.isPolicy.value
                                          ? const Icon(Icons.done,
                                              color: Colors.green)
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.white.withOpacity(0.8),
                                ),
                              ),
                              onPressed: () async {
                                await controller.onSubmit();
                              },
                              child: Text(
                                controller.isPageLogin.value
                                    ? "Login"
                                    : "Get Started",
                                style: TextStyles.medium(
                                  14,
                                  Colors.black,
                                  TextDecoration.none,
                                ),
                              ),
                            ),
                            if (controller.isPageLogin.value)
                              const SizedBox(
                                height: 8,
                              ),
                            if (controller.isPageLogin.value &&
                                controller.isUserNotNull! &&
                                controller.isSupportFingerprint)
                              IconButton(
                                onPressed: () {
                                  controller.loginFingerPrint();
                                },
                                icon: SizedBox(
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  child: const Image(
                                    image: AssetImage(
                                      "assets/images/fingerprint.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (controller.isPageLogin.value)
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyles.medium(
                                    14,
                                    Colors.black,
                                    TextDecoration.none,
                                  ),
                                ),
                              ),
                            if (controller.isPageLogin.value)
                              SizedBox(
                                height: size.height * 0.1,
                              ),
                            if (controller.isPageLogin.value)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ALREADY HAVE AN ACCOUNT? ",
                                    style: TextStyles.medium(
                                      14,
                                      Colors.black,
                                      TextDecoration.none,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.changePageAddEdit();
                                    },
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyles.bold(
                                        14,
                                        Colors.black,
                                        TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class _backgroundWidget extends StatelessWidget {
  const _backgroundWidget({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.height / 2,
        height: size.height / 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: const AssetImage("assets/images/football.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.4),
              BlendMode.dstATop,
            ),
          ),
        ),
      ),
    );
  }
}
