import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/core/theming/app_style.dart';
import 'package:chatbot_app/core/utils/image_constant.dart';
import 'package:chatbot_app/core/utils/size_utils.dart';
import 'package:chatbot_app/model/Token.dart';
import 'package:chatbot_app/screen/chat.dart';
import 'package:chatbot_app/services/api.dart';

import '../core/fonctions.dart';
import '../model/User.dart';

class Signup2 extends StatefulWidget{
  Signup2({Key? key})
      : super(
    key: key,
  );

  @override
  State<Signup2> createState() => _signupState();
}

class _signupState extends State<Signup2> with TickerProviderStateMixin {
  late bool progressbarVisibility = false;
  late Color textFieldColor = UIColors.blueGray100;
  late String textFieldMessage = "";
  late Animation<double> animation;
  late AnimationController controller;
  final emailText = TextEditingController();
  final pwdText = TextEditingController();
  final API = Api();

  bool sexe=false,privacyPolicy=false,
      show_loading=false;
  bool loading_datas=true;
  String photo='';
  int pageIndex=0;

  String parrain = "none";
  String parti = "none";

  final namecontroller = TextEditingController();
  final prenomcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  final pwdCfcontroller = TextEditingController();


  late Color emailFieldColor = UIColors.primaryColor;
  late Color pwdFieldColor = UIColors.primaryColor;
  late Color pwdCfFieldColor = UIColors.primaryColor;
  late Color nomFieldColor = UIColors.primaryColor;
  late Color prenomFieldColor = UIColors.primaryColor;

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
                Text('Créer mon compte',
                  style: AppStyle.txtInter(size: 28),
                ),
                Padding(padding: getPadding(top:25)),
                TextField(
                  controller: namecontroller,
                  style: AppStyle.txtInter(size: 20),
                  keyboardType: TextInputType.text,
                  cursorColor: UIColors.cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Prenom',
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
                Padding(padding: getPadding(top:15)),
                TextField(
                  controller: prenomcontroller,
                  style: AppStyle.txtInter(size: 20),
                  keyboardType: TextInputType.text,
                  cursorColor: UIColors.cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Nom',
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
                Padding(padding: getPadding(top:15)),
                TextField(
                  controller: emailcontroller,
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
                Padding(padding: getPadding(top:15)),
                TextField(
                  controller: pwdcontroller,
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
                Padding(padding: getPadding(top:15)),
                TextField(
                  controller: pwdCfcontroller,
                  style: AppStyle.txtInter(size: 20),
                  obscureText: true,
                  cursorColor: UIColors.cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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
                Padding(padding: getPadding(top: 15)),
                Text('$textFieldMessage',
                  style: AppStyle.txtArimoHebrewSubset(size: 16).copyWith(
                    fontStyle: FontStyle.italic,
                    color: textFieldColor
                  ),
                ),
                Padding(padding: getPadding(top:15)),
                GestureDetector(
                  onTap: () {
                    register();
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                  padding: getPadding(
                    top: 12,
                    bottom: 12,
                  ),
                  width: BodyWidth(),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: UIColors.primaryColor,
                        borderRadius: BorderRadius.circular(35),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Créer",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInter(size: 20,color: UIColors.primaryAccent),
                              ),
                              Visibility(
                                visible: show_loading,
                                child: Padding(
                                  padding: getPadding(
                                    left: 20,
                                  ),
                                  child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                  Center(
                                      child: CircularProgressIndicator(
                                        color: UIColors.primaryAccent,
                                        strokeWidth: 2,
                                      )),
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
        ]

      )
    );
  }

  void register() {
    String data = "starting register .... ";
    log('Chatbot DEBUG: -- Signup--  $data');
    show_loading = true;
    textFieldMessage = "";
    bool emailValid = RegExp(r'\S+@\S+\.\S+').hasMatch(emailcontroller.text.trim());
    if (namecontroller.text.isEmpty) {
      nomFieldColor = Colors.redAccent;
      textFieldMessage = "Please fill correctly the case First Name*";
      textFieldColor = Colors.redAccent;
      show_loading = false;
    }
    else if (prenomcontroller.text.isEmpty) {
      prenomFieldColor = Colors.redAccent;
      textFieldMessage = "Please fill correctly the case Second Name*";
      textFieldColor = Colors.redAccent;
      show_loading = false;
    }
    else if (pwdcontroller.text.isEmpty) {
      pwdFieldColor = Colors.redAccent;
      textFieldMessage = "Please fill correctly the case password*";
      textFieldColor = Colors.redAccent;
      show_loading = false;
    }
    else if (pwdcontroller.text != pwdCfcontroller.text) {
      pwdCfFieldColor = Colors.redAccent;
      textFieldMessage = "Password not matching, Please fill correctly the cases";
      textFieldColor = Colors.redAccent;
      show_loading = false;
    }
    else if (!emailValid) {
      emailFieldColor = Colors.redAccent;
      textFieldMessage = "Email is incorrect";
      textFieldColor = Colors.redAccent;
      show_loading = false;
    }
    else {
      User inscription=new User();
      inscription.nom=namecontroller.text;
      inscription.prenom=prenomcontroller.text;
      inscription.email=emailcontroller.text.trim();
      inscription.password=pwdcontroller.text;
      Token? tokenFromAPI;
      var body;
      API.signup(inscription).then((response) => {
        if(response.statusCode==200 || response.statusCode==201){
          textFieldMessage='Sign up successfully done',
          toast('Sign up successfully done'),
          textFieldColor=UIColors.primaryColor,
          API.login(inscription.email, inscription.password).then((response1) async => {
            if (response1.statusCode == 200 || response1.statusCode==201)
              {
                tokenFromAPI = Token.fromJson(jsonDecode(response1.body)),
                print('==== Token : ' +tokenFromAPI!.toJson().toString()),
                tokenFromAPI!.time = DateTime.now().millisecondsSinceEpoch / 1000 + (3600 * 24),
                tokenFromAPI!.password = pwdText.text.toString(),
                tokenFromAPI!.email = emailText.text.toString().trim(),
                // print('==== Token :' +tokenFromAPI!.toJson().toString()),
                await saveKey('token', tokenFromAPI!.toJson().toString()),

                API.getProfile().then((resp1) async => {
                  if (resp1.statusCode == 200 || resp1.statusCode==201){
                    log(jsonDecode(resp1.body).toString()),
                    await saveKey('user',resp1.body.toString()),
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
                show_loading = false,
                textFieldMessage = "Sign in failed. Please check your informations!",
                data = "connexion failed with : user=" +
                    inscription.email.toString().trim() +
                    " and pass=" +
                    inscription.password,
                log('Chatbot DEBUG: $data'),
                data = "connexion failed with : " + response.body,
                log('Chatbot DEBUG: $data'),
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("connexion failed"),
                )),
              }
          })
        }
        else{
          log(response.body.toString()),
          body=json.decode(response.body),
          textFieldMessage='Sign up failed with : '+ body['description'],
          toast('Sign up failed with : '+ body['description'],color: Colors.grey),
          log('Chatbot DEBUG: '+response.body),
          textFieldColor=UIColors.errorColor,
          show_loading=false,
        },
        setState((){}),
      }).onError((error, stackTrace) => {
        textFieldMessage='Sign up failed,Impossible to sync with server',
        toast(textFieldMessage,color: Colors.red),
        log('Chatbot DEBUG: '+stackTrace.toString()),
        show_loading = false,
        setState((){}),
      });
    }
  }

  bool validDate(String date) {
    log('validating date');
    DateFormat format = DateFormat("dd/MM/yyyy");
    log('$date');
    try {
      DateTime dayOfBirthDate = format.parseStrict(date);
      log('birthdate ' + dayOfBirthDate.toString());
      return true;
    } catch (e) {
      log('$e');
      return false;
    }
  }
  int getTime(String date){
    int time=0;
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime dayOfBirthDate = format.parseStrict(date);
    time = (dayOfBirthDate.millisecondsSinceEpoch/1000).floor();
    return time;
  }

}
