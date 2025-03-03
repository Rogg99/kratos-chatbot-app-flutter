import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_app/core/app_export.dart';
import 'package:chatbot_app/screen/login.dart';
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


class PresentationScreen extends StatefulWidget {
  PresentationScreen({Key? key})
      : super(
          key: key,
        );
  @override
  State<PresentationScreen> createState() => Animated();
}

class Animated extends State<PresentationScreen> with TickerProviderStateMixin {
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
            Padding(
              padding: getPadding(
                top: 25,
                bottom: 30,
              ),
              child: Text(
                "Bienvenu(e),Je suis Coco AI, votre assistant de paiements et transactions Kratos",
                maxLines: null,
                textAlign: TextAlign.center,
                style: AppStyle.txtPoppins(weight: 'bold',size: 24,color: UIColors.primaryColor),
              ),
            ),
            // Padding(
            //   padding: getPadding(
            //     top: 25,
            //     bottom: 30,
            //   ),
            //   child: Text(
            //     """Je suis là pour vous assister dans l'exploitation de Kratos Payments """,
            //     maxLines: null,
            //     textAlign: TextAlign.center,
            //     style: AppStyle.txtPoppins(size: 16,color: UIColors.primaryDark),
            //   ),
            // ),
            CustomImageView(
              fit: BoxFit.fitWidth,
              imagePath: ImageConstant.affiche,
              height: 400,
              width: BodyWidth(),
              margin: getMargin(
                top: 42,
              ),
            ),
            Padding(padding: getPadding(top:15)),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
              child:Container(
              padding: getPadding(
                top: 12,
                bottom: 12,
              ),
              width: BodyWidth(),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: UIColors.primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: getPadding(
                        left: 38,
                        right: 38,
                        top: 3,
                        bottom: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding: getPadding(left: 100)),
                          Text(
                            "Continuer",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInter(size: 20,color: UIColors.primaryAccent),
                          ),
                          Padding(padding: getPadding(left: 90)),
                          Icon(Icons.arrow_right_alt_rounded,color: Colors.white,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
