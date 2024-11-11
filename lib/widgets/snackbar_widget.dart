import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarWidget {
  static GetSnackBar snackBarWidget(
          {required String title,
          required String message,
          required bool isSuccess}) =>
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.8),
        duration: const Duration(seconds: 2),
        titleText: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        icon: Icon(
          isSuccess ? Icons.done : Icons.remove,
          color: isSuccess ? Colors.green : Colors.red,
        ),
      );
}
