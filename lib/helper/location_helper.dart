import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_delivery_boy/features/home/widgets/permission_dialog_widget.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationHelper {
  static void checkPermission(BuildContext context, {Function? callBack}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showDialog(
        context: Get.context!, barrierDismissible: false,
        builder: (ctx) => PermissionDialogWidget(
          isDenied: true,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            if(callBack != null) {
              checkPermission(Get.context!, callBack: callBack);
            }

          },
        ),
      );
    }
    else if(permission == LocationPermission.deniedForever) {
      showDialog(
        context: Get.context!, barrierDismissible: false,
        builder: (context) => PermissionDialogWidget(
          isDenied: false,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            if(callBack != null) {
              checkPermission(Get.context!, callBack: callBack);
            }

          },
        ),);
    }else if(callBack != null){
      callBack();
    }
  }

  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude'
        '&destination=$destinationLatitude,$destinationLongitude&mode=d';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrlString(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

}