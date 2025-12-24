import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediecom/core/common/app/application_details.dart';
import 'package:mediecom/features/cart/data/data_sources/cart_service.dart';
import 'package:mediecom/features/notification/data/notifications.dart';
import 'package:mediecom/firebase_options.dart';
import 'package:mediecom/injection_container.dart';
import 'package:mediecom/myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();

  await NotificationService().initialize();

  await CartService.init();
  await CartBackupService.init();

  await ApplicationRepository().initialize();

  runApp(MyApp());
}
