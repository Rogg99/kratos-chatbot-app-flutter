import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/core/fonctions.dart';
import 'package:chatbot_app/core/theming/app_style.dart';
import 'package:chatbot_app/core/utils/image_constant.dart';
import 'package:chatbot_app/core/utils/size_utils.dart';
import 'package:chatbot_app/model/Token.dart';
import 'package:chatbot_app/screen/chat.dart';
import 'package:chatbot_app/screen/register.dart';
import 'package:chatbot_app/services/api.dart';

import '../model/User.dart';

class Login extends StatefulWidget{
  Login({Key? key})
      : super(
    key: key,
  );

  @override
  State<Login> createState() => _loginState();
}

class _loginState extends State<Login> with TickerProviderStateMixin {
  late bool progressbarVisibility = false;
  late Color textFieldColor = UIColors.blueGray100;
  late String textFieldMessage = "";
  late Animation<double> animation;
  late AnimationController controller;
  final emailText = TextEditingController();
  final pwdText = TextEditingController();
  final API = Api();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(begin: 0, end: 360).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    emailText.dispose();
    pwdText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children:[
          Padding(padding: getPadding(top:100)),
          Container(
            padding: getPadding(all:10),
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 170,
            decoration: BoxDecoration(
                color: UIColors.primaryAccent,
                borderRadius: BorderRadius.circular(20)
            ),
            child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  Image.asset(
                    ImageConstant.logo_notext,
                    width: BodyWidth()-60,
                    fit:BoxFit.fitHeight,
                    height: 150,
                  ),]
                ),
          ),
          Padding(padding: getPadding(top:10)),
          Container(
            margin: getMargin(left: 20,right: 20),
            padding: getPadding(all: 15),
            decoration: BoxDecoration(
              color: UIColors.primaryAccent,
              borderRadius: BorderRadius.circular(20)
            ),
            child:
            Column(
              children: [
                Text('Login',
                  style: AppStyle.txtInter(size: 28),
                ),
                Padding(padding: getPadding(top:20)),
                Padding(padding: getPadding(top:5)),
                TextField(
                  controller: emailText,
                  style: AppStyle.txtInter(size: 20),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: UIColors.cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: UIColors.edittextFillColor,
                    border: OutlineInputBorder(
                      gapPadding: 1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: UIColors.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                ),
                Padding(padding: getPadding(top:10)),
                Padding(padding: getPadding(top:5)),
                TextField(
                  controller: pwdText,
                  style: AppStyle.txtInter(size: 20),
                  obscureText: true,
                  cursorColor: UIColors.cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: UIColors.edittextFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: UIColors.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(padding: getPadding(top:5)),
                Text('$textFieldMessage',
                  style: AppStyle.txtArimoHebrewSubset(size: 16).copyWith(
                    fontStyle: FontStyle.italic,
                    color: textFieldColor
                  ),
                ),
                Padding(padding: getPadding(top:15)),
                Container(
                  padding: getPadding(
                    top: 12,
                    bottom: 12,
                  ),
                  width: BodyWidth(),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      connect();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Connexion",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInter(size: 20,color: UIColors.primaryAccent),
                              ),
                              Visibility(
                                visible: progressbarVisibility,
                                child: Padding(
                                  padding: getPadding(
                                    left: 20,
                                  ),
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(controller.value),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        value: 0.9,
                                        color: UIColors.primaryAccent,
                                        semanticsLabel: 'Circular progress indicator',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: getPadding(top:20)),
              ],
            ),

          ),

          Padding(padding: getPadding(top:20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Or',
                style: AppStyle.txtInter(size:18 ),
              ),
            ],
          ),
          Padding(padding: getPadding(top:40)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup2()));
            },
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Créer mon Compte',
                  style: AppStyle.txtInter(size: 20,color: UIColors.primaryColor),
                ),
              ],
            ),
          ),
        ]

      )
    );
  }

  void connect() async {
    // await API.createTableUser();
    String data = "starting connexion .... ";
    log('Chatbot DEBUG: $data');
    var usrBody;
    progressbarVisibility = true;
    textFieldMessage = "";
    bool emailValid = RegExp(r'\S+@\S+\.\S+').hasMatch(emailText.value.toString().trim());
    if (emailValid && pwdText.value.toString().isNotEmpty) {
      Token? tokenFromAPI;
      API.login(emailText.text.toString().trim(), pwdText.text.toString()).then((response) async => {
        // log(response.body),
        if (response.statusCode == 200 || response.statusCode==201)
          {
            tokenFromAPI = Token.fromJson(jsonDecode(response.body)),
            tokenFromAPI!.time = DateTime.now().millisecondsSinceEpoch / 1000 + (3600 * 24),
            tokenFromAPI!.password = pwdText.text.toString(),
            tokenFromAPI!.email = emailText.text.toString().trim(),
            // print(tokenFromAPI!.toJson().toString()),
            await saveKey('token', tokenFromAPI!.toJson().toString()),

            // await API.getToken().then((value) => {
            //   print(value.access),
            // }),
            // print(tokenFromAPI!.access),
            API.getProfile().then((resp1) async => {
              if (resp1.statusCode == 200  || resp1.statusCode==201){
                // log(jsonDecode(resp1.body)['data'].toString()),
                saveKey('user',resp1.body.toString()),
                // await API.getUI_user().then((value) => {
                //   print(value.id),
                // }),
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatView())),
              }
              else
                {
                  textFieldColor = Colors.redAccent,
                  progressbarVisibility = false,
                  textFieldMessage = "Echec de connexion! Veuilllez reessayez",
                  log('Chatbot DEBUG: connexion error'),
                  log('Chatbot DEBUG: '+ resp1.body),
                  data = "connexion failed with : " + resp1.body,
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("connexion failed"),
                  )),
                }
            }),
          }
        else
          {
            textFieldColor = Colors.redAccent,
            progressbarVisibility = false,
            textFieldMessage = "Echec de connexion, Veuillez verifier vos informations de connexion!",
            data = "connexion failed with : user=" + emailText.text.toString().trim() + " and pass=" + pwdText.text.toString(),
            log('Chatbot DEBUG: $data'),
            data = "connexion failed with : " + response.statusCode.toString(),
            log('Chatbot DEBUG: $data'),
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("connexion failed"),
            )),
          }
      });
    }
    else {
      textFieldColor = Colors.redAccent;
      progressbarVisibility = false;
      textFieldMessage = "Veuillez verifier vos informations de connexion!";
      data = "connexion failed with : user=" +
          emailValid.toString() +
          " and pass=" +
          pwdText.text.toString().isNotEmpty.toString();
      log('Chatbot DEBUG: $data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("connexion failed"),
      ));
    }
  }
}
