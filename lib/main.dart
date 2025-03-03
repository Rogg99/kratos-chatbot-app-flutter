import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/screen/splashscreen.dart';
import 'package:chatbot_app/services/api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chatbot_app/core/fonctions.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
var API = Api();

ThemeMode _themeMode = ThemeMode.light;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (kIsWeb) {

    // Initialize FFI
    //sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfiWeb;
    // Android-specific code
  }

  //await saveKey('theme','dark');
  try {
    if (await getKey('token').then((value) => value != '')) {
      API.keepTokenAlive(force: true);
    }
  }
  on Exception catch (e) {
    await saveKey('theme','light');
    await saveKey('language','français');
  }

  try{
    int.parse(await getKey('last_update'));
  }
  on Exception catch(e){
    await saveKey('theme','light');
    await saveKey('language','français');
    await saveKey('last_update', '0');
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  MyApp({Key? key})
      : super(
    key: key,
  );
  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => MyApp_();
}

class MyApp_ extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UIColors.lightTheme(),
      darkTheme: UIColors.darkTheme(),
      themeMode: _themeMode,
      title: 'Chatbot',
      debugShowCheckedModeBanner: false,
      home: SplashscreenScreen(),
    );
  }
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
