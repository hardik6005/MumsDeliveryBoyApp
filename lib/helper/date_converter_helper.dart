import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateConverterHelper {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String localDateToIsoStringAMPM(DateTime dateTime, BuildContext context) {
    return DateFormat('${_timeFormatter(context)} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeRange(String start, String end, BuildContext context) {
    DateTime startTime = DateFormat('HH:mm:ss').parse(start);
    DateTime endTime = DateFormat('HH:mm:ss').parse(end);
    return '${DateFormat(_timeFormatter(context)).format(startTime)} - ${DateFormat(_timeFormatter(context)).format(endTime)}';
  }

  static String _timeFormatter(BuildContext context) {
    return Provider.of<SplashProvider>(context, listen: false).configModel!.timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
  }

}
