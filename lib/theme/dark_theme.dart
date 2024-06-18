import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFE5862),
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardColor: const Color(0xFF252525),
  hintColor: const Color(0xFF979797),
  focusColor: const Color(0xFFADC4C8),
  shadowColor: Colors.black.withOpacity(0.4),

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
