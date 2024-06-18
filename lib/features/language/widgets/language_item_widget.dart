import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/language/domain/models/language_model.dart';
import 'package:grocery_delivery_boy/features/language/providers/language_provider.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';

class LanguageItemWidget extends StatelessWidget {
  const LanguageItemWidget({
    Key? key,
    required this.languageModel,
    required this.languageProvider,
    required this.index,
  }) : super(key: key);

  final LanguageModel languageModel;
  final LanguageProvider languageProvider;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        languageProvider.changeSelectIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor.withOpacity(.15) : null,
          border: Border(
            top: BorderSide(
              width: languageProvider.selectIndex == index ? 1.0 : 0.0,
              color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
            ),
            bottom: BorderSide(
              width: languageProvider.selectIndex == index ? 1.0 : 0.0,
              color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: languageProvider.selectIndex == index
                    ? Colors.transparent
                    : (languageProvider.selectIndex! - 1) == (index! - 1)
                    ? Colors.transparent
                    : Theme.of(context).dividerColor,
              ),

            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Image.asset(languageModel.imageUrl!, width: 34, height: 34),
              const SizedBox(width: 30),

              Text(
                languageModel.languageName!,
                style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),

            ]),

            languageProvider.selectIndex == index ? Image.asset(
              Images.done,
              width: 17,
              height: 17,
              color: Theme.of(context).primaryColor,
            ) : const SizedBox.shrink()
          ]),
        ),
      ),
    );
  }
}
