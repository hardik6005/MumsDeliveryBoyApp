import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/config_model.dart';
import 'package:grocery_delivery_boy/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:grocery_delivery_boy/helper/email_checker_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_app_bar_widget.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:provider/provider.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();

  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    _countryDialCode = CountryCode.fromCountryCode(splashProvider.configModel!.country!).dialCode;
    authProvider.onPickDmImage(false, true);
    authProvider.setIdentityTypeIndex(authProvider.identityTypeList[0], false);

    authProvider.loadBranchList();
    authProvider.setBranchIndex(0, isUpdate: false);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('delivery_man_registration', context)),
      body: Consumer<AuthProvider>(builder: (context,  authProvider, _) {
        List<int> branchIndexList = _getBranchIndexList(authProvider.branchList ?? []);

        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Align(alignment: Alignment.center, child: Text(
                getTranslated('delivery_man_image', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Align(alignment: Alignment.center, child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: authProvider.pickedImage != null ? kIsWeb ? Image.network(
                    authProvider.pickedImage!.path, width: 150, height: 120, fit: BoxFit.cover,
                  ) : Image.file(
                    File(authProvider.pickedImage!.path), width: 150, height: 120, fit: BoxFit.cover,
                  ) : Image.asset(
                    Images.placeholderUser, width: 150, height: 120, fit: BoxFit.cover,
                  ),
                ),

                Positioned(bottom: 0, right: 0, top: 0, left: 0, child: InkWell(
                  onTap: () => authProvider.onPickDmImage(true, false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                )),
              ])),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(child: CustomTextFieldWidget(
                  hintText: getTranslated('first_name', context),
                  controller: _fNameController,
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  focusNode: _fNameNode,
                  nextFocus: _lNameNode,
                  showTitle: true,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CustomTextFieldWidget(
                  hintText: getTranslated('last_name', context),
                  controller: _lNameController,
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  focusNode: _lNameNode,
                  nextFocus: _emailNode,
                  showTitle: true,
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                hintText: getTranslated('email', context),
                controller: _emailController,
                focusNode: _emailNode,
                nextFocus: _phoneNode,
                inputType: TextInputType.emailAddress,
                showTitle: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Row(children: [
                  Container(
                    height: 59,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: CountryCodePicker(
                      dialogBackgroundColor: Theme.of(context).cardColor,
                      onChanged: (CountryCode countryCode) {
                        _countryDialCode = countryCode.dialCode;
                      },
                      initialSelection: _countryDialCode,
                      favorite: [_countryDialCode!],
                      showDropDownButton: true,
                      padding: EdgeInsets.zero,
                      showFlagMain: true,
                      flagWidth: 30,
                      textStyle: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.titleMedium!.color,
                      ),
                    ),
                  ),

                  Expanded(flex: 1, child: SizedBox(
                    height: 60,
                    child: CustomTextFieldWidget(
                      borderRadius: 0,
                      hintText: getTranslated('phone', context),
                      controller: _phoneController,
                      focusNode: _phoneNode,
                      nextFocus: _passwordNode,
                      inputType: TextInputType.phone,
                    ),
                  )),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                hintText: getTranslated('password', context),
                controller: _passwordController,
                focusNode: _passwordNode,
                nextFocus: _confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                showTitle: true,
                isShowSuffixIcon: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                hintText: getTranslated('confirm_password', context),
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordNode,
                nextFocus: _identityNumberNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                showTitle: true,
                isShowSuffixIcon: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('branch', context),
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  authProvider.branchList != null ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: DropdownButton<int>(
                      hint: Text(
                        getTranslated('select_your_branch', context),
                        style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                      value: authProvider.selectedBranchIndex,
                      items: branchIndexList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(authProvider.branchList![value].name!),
                        );
                      }).toList(),
                      onChanged: (value)=> authProvider.setBranchIndex(value!),
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ) : const Center(child: CircularProgressIndicator()),
                ])),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('identity_type', context),
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                    ),
                    child: DropdownButton<String>(
                      value: authProvider.identityTypeList[authProvider.identityTypeIndex],
                      items: authProvider.identityTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        authProvider.setIdentityTypeIndex(value, true);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ),
                ])),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CustomTextFieldWidget(
                  hintText: getTranslated('identity_number', context),
                  controller: _identityNumberController,
                  focusNode: _identityNumberNode,
                  inputAction: TextInputAction.done,
                  showTitle: true,
                )),

              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Text(
                getTranslated('identity_images', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: authProvider.pickedIdentities.length+1,
                  itemBuilder: (context, index) {
                    XFile? file = index == authProvider.pickedIdentities.length
                        ? null : authProvider.pickedIdentities[index];
                    if(index == authProvider.pickedIdentities.length) {
                      return InkWell(
                        onTap: () => authProvider.onPickDmImage(false, false),
                        child: Container(
                          height: 120, width: 150, alignment: Alignment.center, decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                        ),
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: kIsWeb ? Image.network(
                            file!.path, width: 150, height: 120, fit: BoxFit.cover,
                          ) : Image.file(
                            File(file!.path), width: 150, height: 120, fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0, top: 0,
                          child: InkWell(
                            onTap: () => authProvider.onRemoveIdentityImage(index),
                            child: const Padding(
                              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Icon(Icons.delete_forever, color: Colors.red),
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),

            ]),
          )),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              isLoading: authProvider.isLoading,
              btnTxt: getTranslated('submit', context),
              onTap: () => _addDeliveryMan(),
            ),
          ),



        ]);
      }),
    );
  }

  List<int> _getBranchIndexList(List<Branches> branchList) {
    List<int> branchIndexList = [];
    branchIndexList.add(0);

    for(int index=1; index<branchList.length; index++) {
      branchIndexList.add(index);
    }

    return branchIndexList;
  }

  void _addDeliveryMan() async {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();

    PhoneNumber phoneNumber = PhoneNumber.parse(_countryDialCode! + phone);
    String numberWithCountryCode = phoneNumber.international;
    bool isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);

    if(fName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_delivery_man_first_name', Get.context!));

    }else if(lName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_delivery_man_last_name', Get.context!));

    }else if(email.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_delivery_man_email_address', Get.context!));

    }else if(EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_a_valid_email_address', Get.context!));

    }else if(phone.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_delivery_man_phone_number', Get.context!));

    }else if(!isValid) {
      showCustomSnackBarHelper(getTranslated('enter_a_valid_phone_number', Get.context!));

    }else if(password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password_for_delivery_man', Get.context!));

    }else if(password.length < 8) {
      showCustomSnackBarHelper(getTranslated('password_should_be', Get.context!));

    }else if(confirmPassword != password) {
      showCustomSnackBarHelper(getTranslated('password_does_not_matched', Get.context!));

    }else if(identityNumber.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_delivery_man_identity_number', Get.context!));

    }else if(authProvider.pickedImage == null) {
      showCustomSnackBarHelper(getTranslated('upload_delivery_man_image', Get.context!));

    }else {
      authProvider.registerDeliveryMan(DeliveryManBodyModel(
        fName: fName, lName: lName,
        password: password, phone: numberWithCountryCode,
        email: email, identityNumber: identityNumber,
        identityType: authProvider.identityTypeList[authProvider.identityTypeIndex],
        branchId: authProvider.branchList![authProvider.selectedBranchIndex!].id.toString(),
      ));
    }
  }
}

