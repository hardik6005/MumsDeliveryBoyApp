import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/auth/widgets/remember_widget.dart';
import 'package:grocery_delivery_boy/helper/email_checker_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_text_field_widget.dart';
import 'package:grocery_delivery_boy/features/auth/screens/delivery_man_registration_screen.dart';
import 'package:grocery_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController?.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail();
    _passwordController!.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(body: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Form(
          key: _formKeyLogin,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  Images.logo,
                  height: MediaQuery.of(context).size.height / 4.5,
                  fit: BoxFit.scaleDown,
                  matchTextDirection: true,
                ),
              ),

              Center(child: Text(getTranslated('login', context), style: rubikRegular.copyWith(
                fontSize: 24, color: Theme.of(context).hintColor,
              ))),
              const SizedBox(height: 35),

              Text(getTranslated('email_address', context), style: rubikRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextFieldWidget(
                hintText: getTranslated('demo_gmail', context),
                isShowBorder: true,
                focusNode: _emailFocus,
                nextFocus: _passwordFocus,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                getTranslated('password', context),
                style: rubikRegular,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextFieldWidget(
                hintText: getTranslated('password_hint', context),
                isShowBorder: true,
                isPassword: true,
                isShowSuffixIcon: true,
                focusNode: _passwordFocus,
                controller: _passwordController,
                inputAction: TextInputAction.done,
              ),
              const SizedBox(height: 22),

              // for remember me section
              const RememberWidget(),
              const SizedBox(height: 22),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  authProvider.loginErrorMessage!.isNotEmpty
                      ? CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: 5)
                      : const SizedBox.shrink(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authProvider.loginErrorMessage ?? "",
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                ],
              ),

              // for login button
              const SizedBox(height: 10),
              CustomButtonWidget(
                isLoading: authProvider.isLoading,
                btnTxt: getTranslated('login', context),
                onTap: () async {
                  String email = _emailController!.text.trim();
                  String password = _passwordController!.text.trim();
                  if (email.isEmpty) {
                    showCustomSnackBarHelper(getTranslated('enter_email_address', context));
                  }else if (EmailCheckerHelper.isNotValid(email)) {
                    showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
                  }else if (password.isEmpty) {
                    showCustomSnackBarHelper(getTranslated('enter_password', context));
                  }else if (password.length < 6) {
                    showCustomSnackBarHelper(getTranslated('password_should_be', context));
                  }else {
                    authProvider.login(emailAddress: email, password: password).then((status) async {
                      if (status.isSuccess) {
                        if (authProvider.isActiveRememberMe) {
                          authProvider.saveUserNumberAndPassword(email, password);
                        } else {
                          authProvider.clearUserEmailAndPassword();
                        }
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 10),

              (splashProvider.configModel?.toggleDmRegistration ?? false) ? TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(1, 40),
                ),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DeliveryManRegistrationScreen()),
                ),
                child: RichText(text: TextSpan(children: [
                  TextSpan(text: '${getTranslated('join_as_a', context)} ', style: rubikRegular.copyWith(color: Theme.of(context).disabledColor)),
                  TextSpan(text:getTranslated('delivery_man', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                ])),
              ) : const SizedBox(),


            ],
          ),
        ),
      ),
    ));
  }
}

