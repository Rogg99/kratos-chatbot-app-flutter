import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_app/core/app_export.dart';
import 'package:chatbot_app/screen/login.dart';
import 'package:chatbot_app/screen/presentation.dart';
import 'package:chatbot_app/widgets/custom_image_view.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/model/Token.dart';

import 'package:chatbot_app/services/api.dart';

import '../core/fonctions.dart';
import 'chat.dart';

Color dot1 = UIColors.blueGray100;
Color dot2 = UIColors.blueGray100;
Color dot3 = UIColors.blueGray100;
Color dot4 = UIColors.blueGray100;
Color dot5 = UIColors.blueGray100;
Color dot6 = UIColors.blueGray100;


class SplashscreenScreen extends StatefulWidget {
  SplashscreenScreen({Key? key})
      : super(
          key: key,
        );
  @override
  State<SplashscreenScreen> createState() => Animated();
}

class Animated extends State<SplashscreenScreen> with TickerProviderStateMixin {
  String uitheme='light';
  late Animation<double> animation;
  late AnimationController controller;
  final API = Api();
  var results;
  @override
  void initState() {
      getKey('theme').then((value) => (){
        log('AppTheme : $value');
          uitheme=value;
       setState(() {
       });
     });
    super.initState();
    int i = 1;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    animation = Tween<double>(begin: 0, end: 6).animate(controller)
      ..addListener(() {
        setState(() {
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isCompleted) {
      Token? tokenFromAPI;
      API.getToken().then((value) => {
            if (value != null)
              {
                tokenFromAPI = value,
                // log('Chatbot DEBUG: local token access:  ' + value.toJson().toString()),
                log('Chatbot DEBUG: local token time :  ' + tokenFromAPI!.time.floor().toString()),
                log('Chatbot DEBUG: actual time :  ' + (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString()),
                if (tokenFromAPI!.time > DateTime.now().millisecondsSinceEpoch / 1000)
                  {
                    log('Chatbot DEBUG: local token access not expired :  ' + tokenFromAPI!.access),
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatView())),
                  }
                else
                  {
                    log('Chatbot DEBUG: local token access expired '),
                    log('Chatbot DEBUG: refreshing token '),
                    API.login(tokenFromAPI!.email, tokenFromAPI!.password).then((response) => {
                          if (response.statusCode == 200)
                            {
                              results = json.decode(response.body),
                              log("DEBUG Chatbot : new token access ,  : " + results['access'].toString()),
                              
                              saveKey('token', jsonEncode(Token(
                                      password: tokenFromAPI!.password,
                                      email: tokenFromAPI!.email,
                                      refresh: results['access'],
                                      access: results['access'],
                                      time: DateTime.now().millisecondsSinceEpoch / 1000 + (3600 * 24))))
                                  .then((resp) =>
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatView())),
                              ),
                            }
                          else{
                              log('Chatbot DEBUG: auto login failed'),
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())),
                            }
                        }),
                  }
              }
            else
              Timer(
                  Duration(seconds: 1),
                  () =>
                  {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PresentationScreen())),
                      }),
          });
    }
    return Scaffold(
      backgroundColor: UIColors.primaryAccent,
      body: Container(
        width: double.maxFinite,
        padding: getPadding(
          left: 25,
          right: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              fit: BoxFit.fitHeight,
              imagePath: ImageConstant.logo_dark,
              height: 300,
              width: BodyWidth(),
              margin: getMargin(
                top: 42,
              ),
            ),
            Padding(
              padding: getPadding(
                top: 71,
                bottom: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  decoration: BoxDecoration(
                    color: animation.value >= 1.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  margin: getMargin(left: 19,),
                  decoration: BoxDecoration(
                    color: animation.value >= 2.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  margin: getMargin(left: 19,),
                  decoration: BoxDecoration(
                    color: animation.value >= 3.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  margin: getMargin(left: 19,),
                  decoration: BoxDecoration(
                    color: animation.value >= 4.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  margin: getMargin(left: 19,),
                  decoration: BoxDecoration(
                    color: animation.value >= 5.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
                Container(
                  height: getSize(15),
                  width: getSize(15),
                  margin: getMargin(left: 19,),
                  decoration: BoxDecoration(
                    color: animation.value >= 6.0 ? UIColors.primaryColor : UIColors.blueGray100,
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(7,),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: getPadding(
                top: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Powered By '),
                  Padding(padding: getPadding(left: 10)),
                  CustomImageView(
                    fit: BoxFit.cover,
                    imagePath: ImageConstant.logo_kratos,
                    height: 80,
                    width: 170,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
