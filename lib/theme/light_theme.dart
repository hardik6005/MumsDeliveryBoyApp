import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFFFE5862),
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFFADC4C8),
  hintColor: const Color(0xFF52575C),
  shadowColor: Colors.grey[300],
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeDefault),
    displayMedium: TextStyle(fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700,  fontSize: Dimensions.fontSizeDefault),
    titleLarge: TextStyle(fontWeight: FontWeight.w800,  fontSize: Dimensions.fontSizeDefault),
    bodySmall: TextStyle(fontWeight: FontWeight.w900,  fontSize: Dimensions.fontSizeDefault),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);