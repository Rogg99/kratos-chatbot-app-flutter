import 'package:flutter/material.dart';
import 'package:chatbot_app/screen/splashscreen.dart';


class AppRoutes {
  static const String splashscreenScreen = 'splashscreen';
  static Map<String, WidgetBuilder> routes = {
    splashscreenScreen: (context) => SplashscreenScreen(),
  };
}
