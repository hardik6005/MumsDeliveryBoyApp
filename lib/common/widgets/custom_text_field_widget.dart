import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/language/providers/language_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function? onTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool isSearch;
  final LanguageProvider? languageProvider;
  final TextCapitalization capitalization;
  final bool showTitle;
  final double borderRadius;




  const CustomTextFieldWidget(
      {Key? key, this.hintText = 'Write something...',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.fillColor,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixIconUrl,
        this.prefixIconUrl,
        this.isSearch = false,
        this.languageProvider,
        this.capitalization = TextCapitalization.none,
        this.showTitle = false,
        this.borderRadius = 5
      }) : super(key: key);

  @override

  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.showTitle ? Text(widget.hintText!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)) : const SizedBox(),
      SizedBox(height: widget.showTitle ? Dimensions.paddingSizeExtraSmall : 0),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Theme.of(context).cardColor,
          border: Border.all(color: widget.isShowBorder ? Theme.of(context).hintColor.withOpacity(0.5) : Colors.transparent),
        ),
        child: TextField(
          textCapitalization: widget.capitalization,
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          textInputAction: widget.inputAction,
          keyboardType: widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(style: BorderStyle.none, width: 0),
            ),
            isDense: true,
            hintText: widget.hintText,
            fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            hintStyle: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.4)),
            filled: true,
            prefixIcon: widget.isShowPrefixIcon
                ? Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
              child: Image.asset(widget.prefixIconUrl!),
            )
                : const SizedBox.shrink(),
            prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
            suffixIcon: widget.isShowSuffixIcon
                ? widget.isPassword
                ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(.3)),
                onPressed: _toggle)
                : widget.isIcon
                ? Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
              child: Image.asset(
                widget.suffixIconUrl!,
                width: 15,
                height: 15,
              ),
            )
                : null
                : null,
          ),
          onTap: widget.onTap as void Function()?,
          onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
        ),
      ),

    ]);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
