import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/language/domain/models/language_model.dart';
import 'package:grocery_delivery_boy/features/language/domain/reposotories/language_repo.dart';

class LanguageProvider with ChangeNotifier {
  final LanguageRepo? languageRepo;

  LanguageProvider({this.languageRepo});

  int? _selectIndex = 0;

  int? get selectIndex => _selectIndex;

  changeSelectIndex(int? index) {
    _selectIndex = index;
    notifyListeners();
  }

  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = languageRepo!.getAllLanguages(context: context);
    } else {
      _selectIndex = -1;
      _languages = [];
      languageRepo!.getAllLanguages(context: context).forEach((product) async {
        if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      });
    }
    notifyListeners();
  }

  initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = languageRepo!.getAllLanguages(context: context);
    }
  }
}
