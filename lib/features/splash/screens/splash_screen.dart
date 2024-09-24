import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:grocery_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:grocery_delivery_boy/features/language/screens/choose_language_screen.dart';
import 'package:grocery_delivery_boy/features/maintainance/screens/maintenance_screen.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _onRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(
                  Images.logo,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Text(AppConstants.appName,
                style: rubikBold.copyWith(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _onRoute() {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .maintenanceMode!) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const MaintenanceScreen()));
        } else {
          Timer(const Duration(seconds: 1), () async {
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()));
            } else {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => const ChooseLanguageScreen()));
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          });
        }
      }
    });
  }
}
