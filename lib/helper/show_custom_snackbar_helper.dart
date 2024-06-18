import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/main.dart';

void showCustomSnackBarHelper(String message, {bool isError = true}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Text(message),
  ));
}