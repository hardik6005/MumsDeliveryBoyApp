import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/language/widgets/language_item_widget.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/language/providers/language_provider.dart';
import 'package:grocery_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:grocery_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:grocery_delivery_boy/features/language/widgets/language_search_widget.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromHomeScreen;

  const ChooseLanguageScreen({Key? key, this.fromHomeScreen = false}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
              child: Text(
                getTranslated('choose_the_language', context),
                style: rubikMedium.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
              child: LanguageSearchWidget(),
            ),
            const SizedBox(height: 20),

            Consumer<LanguageProvider>(builder: (context, languageProvider, child) => Expanded(
              child: ListView.builder(
                itemCount: languageProvider.languages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => LanguageItemWidget(
                  languageModel: languageProvider.languages[index],
                  languageProvider: languageProvider, index: index,
                ),
              ),
            )),

        Consumer<LanguageProvider>(builder: (context, languageProvider, child) => Padding(
          padding: const EdgeInsets.only(
            left: Dimensions.paddingSizeLarge,
            right: Dimensions.paddingSizeLarge,
            bottom: Dimensions.paddingSizeLarge,
          ),
          child: CustomButtonWidget(
            btnTxt: getTranslated('save', context),
            onTap: () {
              if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                  AppConstants.languages[languageProvider.selectIndex!].languageCode!,
                  AppConstants.languages[languageProvider.selectIndex!].countryCode,
                ));
                if (widget.fromHomeScreen) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                }
              }else {
                showCustomSnackBarHelper(getTranslated('select_a_language', context));
              }
            },
          ),
        )),


      ])),
    );
  }
}

