import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTheme {
  static const primaryColor = Color.fromARGB(255, 228, 228, 228);
  static const textColor = Colors.black;
  static const padding8px = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  static const padding16px = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static String price(int price) {
    return NumberFormat("#,###", "en_US").format(price).replaceAll(",", ".");
  }
}

class TextStyles {
  static TextStyle thin(
      double size, Color color, TextDecoration textDecoration) {
    return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w100,
      fontSize: size,
      color: color,
      decoration: textDecoration,
    );
  }

  static TextStyle light(
      double size, Color color, TextDecoration textDecoration) {
    return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w300,
      fontSize: size,
      color: color,
      decoration: textDecoration,
    );
  }

  static TextStyle medium(
      double size, Color color, TextDecoration textDecoration) {
    return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w500,
      fontSize: size,
      color: color,
      decoration: textDecoration,
    );
  }

  static TextStyle bold(
      double size, Color color, TextDecoration textDecoration) {
    return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: color,
      decoration: textDecoration,
    );
  }

  static TextStyle black(
      double size, Color color, TextDecoration textDecoration) {
    return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w900,
      fontSize: size,
      color: color,
      decoration: textDecoration,
    );
  }
}
