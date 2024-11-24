import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/sendNotificationHandler.dart';
import 'package:xstore/app/modules/splash/bindings/splash_binding.dart';
import 'package:xstore/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  SendNotificationHandler.initialized();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform, name: "xstore-faa86");
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      GetMaterialApp(
        title: ConstsConfig.appname,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        //initialRoute: isFirstTime ? AppPages.ON_BOARDING : AppPages.MY_HOME,
        initialRoute: AppPages.INITIAL,
        initialBinding: SplashBinding(),
        getPages: AppPages.routes,
      ),
    );
  });
}
