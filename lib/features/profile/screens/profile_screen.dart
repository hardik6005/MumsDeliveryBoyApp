import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/profile/widgets/user_info_widget.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/status_widget.dart';
import 'package:grocery_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:grocery_delivery_boy/features/html/screens/html_viewer_screen.dart';
import 'package:grocery_delivery_boy/features/profile/widgets/menu_button_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        getTranslated('my_profile', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderUser,
                              width: 80, height: 80,
                              fit: BoxFit.fill,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.profilePlaceholder, width: 80, height: 80, fit: BoxFit.cover),

                              image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                            )),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        profileProvider.userInfoModel!.fName != null
                            ? '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}'
                            : "",
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Container(
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('theme_style', context),
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),

                          const StatusWidget()
                        ],
                      ),
                      const SizedBox(height: 20),

                      UserInfoWidget(text: profileProvider.userInfoModel?.fName),
                      const SizedBox(height: 15),

                      UserInfoWidget(text: profileProvider.userInfoModel?.lName),
                      const SizedBox(height: 15),

                      UserInfoWidget(text: profileProvider.userInfoModel?.phone),
                      const SizedBox(height: 20),

                      MenuButtonWidget(icon: Icons.privacy_tip, title: getTranslated('privacy_policy', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: true)));
                      }),
                      const SizedBox(height: 10),

                      MenuButtonWidget(icon: Icons.list, title: getTranslated('terms_and_condition', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: false)));
                      }),
                      const SizedBox(height: 10),

                      MenuButtonWidget(icon: Icons.logout, title: getTranslated('logOut', context), onTap: () {
                        Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                        });
                      }),


                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

