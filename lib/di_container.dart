import 'package:dio/dio.dart';
import 'package:grocery_delivery_boy/features/auth/domain/reposotories/auth_repo.dart';
import 'package:grocery_delivery_boy/features/chat/domain/reposotories/chat_repo.dart';
import 'package:grocery_delivery_boy/features/language/domain/reposotories/language_repo.dart';
import 'package:grocery_delivery_boy/features/order/domain/reposotories/order_repo.dart';
import 'package:grocery_delivery_boy/features/profile/domain/reposotories/profile_repo.dart';
import 'package:grocery_delivery_boy/features/splash/domain/reposotories/splash_repo.dart';
import 'package:grocery_delivery_boy/common/reposotories/tracker_repo.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/chat/providers/chat_provider.dart';
import 'package:grocery_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:grocery_delivery_boy/features/language/providers/language_provider.dart';
import 'package:grocery_delivery_boy/features/order/providers/order_provider.dart';
import 'package:grocery_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/common/providers/theme_provider.dart';
import 'package:grocery_delivery_boy/common/providers/tracker_provider.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TrackerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl(), languageRepo: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => TrackerProvider(trackerRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
