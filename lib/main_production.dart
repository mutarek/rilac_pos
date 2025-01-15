import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

import 'config/color_config.dart';
import 'main.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  FlavorConfig(name: "production", variables: {
    "flavor": "prod",
    "app_name": "sManager.xyz",
    "toast": "Production",
    "sheba_pay_base_url": "https://sapi.shebapay.xyz:4052/",
    "socket_url": "https://sapi.shebapay.xyz:7043",
  });
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Intl.defaultLocale = 'en_US';
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorConfig.primaryColor, // Note RED here
    ),
  );
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAWtwNFv2uBkZ0SjR9waUIgtDtqAoxBK7c',
          appId: '1:1090538708148:android:77f7f1e523ee34cb',
          messagingSenderId: '1090538708148',
          projectId: 'sheba-1500445570528'));

  FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}