import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/features/language/domain/reposotories/language_repo.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LanguageRepo? languageRepo;


  LocalizationProvider({required this.sharedPreferences, required this.languageRepo,}) {
    _loadCurrentLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  bool _isLtr = true;

  Locale get locale => _locale;

  bool get isLtr => _isLtr;

  void setLanguage(Locale locale) {
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    changeLanguage();
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences!.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
        sharedPreferences!.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode == 'en';
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences!.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences!.setString(AppConstants.countryCode, locale.countryCode!);
  }

  Future<void> changeLanguage()async {
    await languageRepo?.changeLanguageApi(languageCode: _locale.languageCode);
  }
}
