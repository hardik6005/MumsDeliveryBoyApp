
import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';


class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.maintenance, width: 200, height: 200),

            Text(getTranslated('maintenance_mode', context),style: const TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700),),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              getTranslated('maintenance_text', context),
              textAlign: TextAlign.center,

            ),

          ]),
        ),
      ),
    );
  }
}
