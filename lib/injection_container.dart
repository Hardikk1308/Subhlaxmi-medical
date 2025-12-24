import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/Helper/ApiHelpers.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/features/account_review/presentation/account_review_injection.dart';
import 'package:mediecom/features/auth/presentation/auth_injection.dart';
import 'package:mediecom/features/master/presentation/master_injection.dart';
import 'package:mediecom/features/notification/notification_injection.dart';
import 'package:mediecom/features/orders/orders_injection.dart';
import 'package:mediecom/features/user/presentation/profile_injection.dart';
import 'package:mediecom/features/cart/presentation/cart_injection.dart';
import 'package:mediecom/features/explore/presentation/explore_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }

  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  if (!sl.isRegistered<Apihelpers>()) {
    sl.registerLazySingleton<Apihelpers>(() => Apihelpers(client: sl()));
  }

  if (!sl.isRegistered<CacheHelper>()) {
    sl.registerLazySingleton<CacheHelper>(() => CacheHelper(sl()));
  }

  initAuth();
  initAccountReview();
  initMaster();
  initProfile();
  initOrders();
  initNotification();
  initCartDependencies();
  initExplore();
}
