import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatbot_app/core/app_export.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/core/utils/image_constant.dart';
import 'package:chatbot_app/core/utils/size_utils.dart';
import 'package:chatbot_app/core/fonctions.dart';
import 'package:chatbot_app/model/Discussion.dart';
import 'package:chatbot_app/services/api.dart';
import 'package:chatbot_app/widgets/custom_image_view.dart';
import 'package:chatbot_app/model/User.dart';
import 'package:chatbot_app/utils/sized_extension.dart';
import 'package:chatbot_app/core/theming/dimens.dart';
import 'package:package_info_plus/package_info_plus.dart';


String SelectedMenu = 'Home';
String appVersion = '1.0.18';
double paddingtitle = 150;

var API = Api();
var user=User();
final ValueNotifier<List<Discussion>> discussions = ValueNotifier([]);

final ValueNotifier<String> langage = ValueNotifier('français');

bool light=false;
bool lang=false;
TextEditingController buttonmaleController = TextEditingController();
String radioGroup = "";
enum languages { Francais, English }
class Settings extends StatefulWidget {
  Settings({Key? key})
      : super(
          key: key,
        );
  @override
  State<Settings> createState() => StateSettings();
}

class StateSettings extends State<Settings> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  List<String> results=[];
  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
  int selected_eventfilter = 0;
  String deviceType = '', keywordEvent = '';
  String userBodyStats='';
  String globalBodyStats='';
  bool isLoading = true,searchdone=true,loadGarages = true ,showGarages = true;
  List<String> categories=[];
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  int statChoice = 0;
  PageController statsPageController = PageController();

  final emailText = TextEditingController();
  static List<String> _titlesView = ['Settings'];

  @override
  void initState() {
    deviceType = getDeviceType();
    //selectedPays=allPays;
    getKey('language').then((value) => {langage.value = value});
    syncViews();
    SelectedMenu = 'Home';
    var height = BodyHeight();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      SizedBox.expand(
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                margin: getMargin(all:8),
                height: getVerticalSize(200,),
                width: getVerticalSize(200,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: UIColors.boxFillColor,
                    image: DecorationImage(
                        image: AssetImage('assets/images/avatar.jpg'),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Padding(
                  padding: getPadding(
                    top: 17,
                  ),
                  child:
                        Text(
                          user.id==''?"...":user.nom+ ' ' + user.prenom,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtArimoHebrewSubset(size: 24,weight: 'bold'),
                        )
              ),
              Padding(padding: getPadding(top: 50)),
              Row(
                children: [
                  Icon(Icons.language),
                  Padding(padding: getPadding(left: 8)),
                  Text('Language',
                    style: AppStyle.txtPoppins(size: 20),),
                  Spacer(),
                  ValueListenableBuilder(
                      valueListenable: langage,
                      builder: (context,value,widget){
                        return
                          Text('Français',
                            style: AppStyle.txtPoppins(color: (langage.value=='Français') || (langage.value=='français') ?UIColors.primaryColor:UIColors.blueGray100,size: 16),
                          );
                      }
                  ),
                  Switch(
                    value: lang,
                    activeColor: UIColors.primaryColor,
                    onChanged: (bool value) async {
                      lang=!lang;
                      if (value==false)
                        await saveKey('language', 'Français');
                      else
                        await saveKey('language', 'English');
                      langage.value = await getKey('language');
                      setState(() {
                      });
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: langage,
                      builder: (context,value,widget){
                        return
                          Text('English',
                            style: AppStyle.txtPoppins(color: (langage.value=='English')?UIColors.primaryColor:UIColors.blueGray100,size: 16),
                          );
                      }
                  ),
                ],
              ),
              Padding(padding: getPadding(top: 10)),
              Row(
                children: [
                  Icon(Icons.logout),
                  Padding(padding: getPadding(left: 8)),
                  GestureDetector(
                    onTap: (){
                      // _showLogoutDialog(context);
                    },
                    child:
                    Text('Log out',
                      style: AppStyle.txtPoppins(size: 20),),
                  ),
                ],
              ),
              Padding(padding: getPadding(top: 30)),
              Row(
                children: [
                  Icon(Icons.help_rounded),
                  Padding(padding: getPadding(left: 8)),
                  Text('Help',
                    style: AppStyle.txtPoppins(size: 20),),
                  Spacer(),
                ],
              ),
              Padding(padding: getPadding(top: 30)),
              Row(
                children: [
                  Icon(Icons.file_open_sharp),
                  Padding(padding: getPadding(left: 8)),
                  Text('Policy',
                    style: AppStyle.txtPoppins(size: 20),),
                  Spacer(),
                ],
              ),
              Padding(padding: getPadding(top: 30)),
              Row(
                children: [
                  Icon(Icons.group),
                  Padding(padding: getPadding(left: 8)),
                  Text('About us',
                    style: AppStyle.txtPoppins(size: 20),),
                  Spacer(),
                ],
              ),
              Padding(padding: getPadding(top: 30)),
              Row(
                children: [
                  Icon(Icons.grain),
                  Padding(padding: getPadding(left: 8)),
                  Text('Version',
                    style: AppStyle.txtPoppins(size: 20),),
                  Spacer(),
                  Text(appVersion,
                    style: AppStyle.txtPoppins(size: 16,color: UIColors.primaryColor),),
                ],
              ),

            ],
          ),
        ),
      ),
    ];

    return Scaffold(
          backgroundColor: UIColors.primaryAccent,
          appBar: AppBar(
            leadingWidth: 90,
            leading: Builder(
                builder: (BuildContext context) {
                  return
                    Stack(
                      children: [

                      ],
                    );

                }) ,
            title:
                Center(
                  child:
                  Text(
                    _titlesView.elementAt(_selectedIndex),
                    style: AppStyle.txtInter(color: Colors.black, weight: 'regular', size: 24),
                  ),
                ),
            backgroundColor: Colors.grey[100],
            elevation: 0,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: Dimens.padding.w),
                  child: GestureDetector(
                    onTap: ()async{
                      // var selfUser=await API.getUI_user().then((value) => value);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user:User())));
                      },
                    child:
                    Container(
                      margin: getMargin(all:8),
                      height: getVerticalSize(60,),
                      width: getVerticalSize(60,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: UIColors.boxFillColor,
                          image: DecorationImage(
                              image: AssetImage('assets/images/avatar.jpg'),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
              )
            ],
          ),
          body: Stack(
            children: [
              _widgetOptions.elementAt(_selectedIndex),
            ],
          ),
        );
  }

  bool firstclick = false;

  void syncViews() async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    user = await API.getUI_user().then((value) => value);
    isLoading=false;
    setState(() {

    });

  }
}





