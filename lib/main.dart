import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_delivery_boy/helper/notification_helper.dart';
import 'package:grocery_delivery_boy/features/chat/providers/chat_provider.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/localization/app_localization.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:grocery_delivery_boy/features/language/providers/language_provider.dart';
import 'package:grocery_delivery_boy/features/order/providers/order_provider.dart';
import 'package:grocery_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/common/providers/theme_provider.dart';
import 'package:grocery_delivery_boy/common/providers/tracker_provider.dart';
import 'package:grocery_delivery_boy/theme/dark_theme.dart';
import 'package:grocery_delivery_boy/theme/light_theme.dart';
import 'package:grocery_delivery_boy/features/splash/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AndroidNotificationChannel? channel;



Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  if(Platform.isIOS) {
    await Firebase.initializeApp();
  }else {
    await Firebase.initializeApp(
    //     options: const FirebaseOptions(
    //   apiKey: 'AIzaSyDTFm7oPur3xhZbVmCkgFkGFcR-44h6Gyo', //current_key
    //   appId: '1:250728969979:android:1dea8003236ec9b275a25e', // mobilesdk_app_id
    //   messagingSenderId: '250728969979', // project_number
    //   projectId: 'grofresh-3986f', // project_id
    // ),
    );

  }

  //firebase crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  //
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  if(defaultTargetPlatform == TargetPlatform.android){
    FirebaseMessaging.instance.requestPermission();
  }
  await di.init();

  if(defaultTargetPlatform == TargetPlatform.android){
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
  }
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: const SplashScreen(),
      builder: (context, widget)=> MediaQuery(
        data: MediaQuery.of(context).copyWith(
            // textScaler: const TextScaler.linear(1),
        ),
        child: Material(child: widget),
      ),

    );
  }
}


class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}