import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_firebase_crashlytics_usage/firebase_options.dart';
import 'package:flutter_firebase_crashlytics_usage/get_it/get_it.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/landing_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    MobileAds.instance.initialize();
    getItLocator();
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    runApp(const MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewmodel(),
      builder: (context, child) => ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (_, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName, 
          theme: ThemeData(   
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(backgroundColor: lightIndigo),
              useMaterial3: true,
              scaffoldBackgroundColor: white,
            ),
          home: const LandingPage(),
        ),
      ),
    );
  }
}
