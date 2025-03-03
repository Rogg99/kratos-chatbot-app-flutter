import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:chatbot_app/screen/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:chatbot_app/core/app_export.dart';
import 'package:chatbot_app/model/Message.dart';
import 'package:chatbot_app/services/api.dart';
import 'package:chatbot_app/widgets/widget_message2.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:positioned_scroll_observer/positioned_scroll_observer.dart';

import '../core/colors/colors.dart';
import '../core/fonctions.dart';
import '../model/Discussion.dart';
import '../model/User.dart';

bool light=false;
var API=Api();
class ChatView extends StatefulWidget{
  ChatView({Key? key,
  })
      : super(
    key: key,
  );
  @override
  State<ChatView> createState() => Chat_();
}
class Chat_ extends State<ChatView>  with TickerProviderStateMixin{
  bool show_login=false;
  bool loadAnswer=false;
  bool loading=true;
  UIMessage answerTo=UIMessage();
  String session="";
  List<UIMessage> messages=[];
  PageController pageController = PageController();
  AutoScrollController scrollcontroller = AutoScrollController();
  final messagecontroller = TextEditingController();
  Discussion? disc;
  User? user;
  List<String> medias = [];
  int lastTime = 0;
  
  Chat_({Key? key,
    this.disc,
  });
  Timer loopCheck = Timer(Duration.zero, () { }) ;

  late final _observer = ScrollObserver.boxMulti(
    axis: Axis.vertical,
    itemCount: messages.length,
  );

  @override
  void initState() {
    messagecontroller.clear();
    load();
    super.initState();
  }

  @override
  void dispose() {
    loopCheck = Timer(Duration.zero, () { }) ;
    messagecontroller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leadingWidth: 48,
          leading: Builder(
              builder: (BuildContext context) {
                return
                Stack(
                  children: [
                    Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.change_circle_outlined,color: Theme.of(context).primaryColorDark,),
                            onPressed: () async {
                              await load();
                            },
                          ),
                        ]
                    ),

                  ],
                );

              }) ,
          title:
            Center(
              child:
              Text('Coco Chatbot',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtInter(color: Colors.black, weight: 'regular', size: 24),
              ),
            ),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings,color: Theme.of(context).primaryColorDark,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ],
        ),
        body:
        Stack(
          children: [
            Container(
              height: BodyHeight()-110,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child:
              Column(
                children: [
                  messages.length == 0?
                  MessageWidget2(
                    message: UIMessage(),
                    head: true,
                  ):SizedBox(),
                  Container(
                    height: BodyHeight()-202,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.separated(
                      separatorBuilder: (context,i){
                        return Container(
                          height: getHorizontalSize(15),
                          width: double.infinity,
                        );
                      },
                      itemBuilder: (context,index){
                        return
                          MessageWidget2(
                            message: messages[index],
                            sender: messages[index].sender == 'user',
                            head: false,
                          );
                      }, itemCount: messages.length,
                    ),
                  ),
                ],
              )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child:
              Container(
                color: UIColors.primaryAccent,
                height: 50  + min(4,(messagecontroller.text.length ~/ 19).toInt())*8,
                padding: getPadding(top: 5),
                child:
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child:
                        Row(
                          children: [
                            Container(
                              height: 40 + min(4,(messagecontroller.text.length ~/ 19).toInt())*8,
                              margin: getMargin(left: 10,top: min(4,(messagecontroller.text.length ~/ 19)) >0 ?7:0),
                              decoration: BoxDecoration(
                                  color: UIColors.blueGray100,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child:
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50 + min(4,(messagecontroller.text.length ~/ 19).toInt())*8,
                                    width: BodyWidth() - (72),
                                    margin: getMargin(right: 10),
                                    decoration: BoxDecoration(
                                        color: UIColors.blueGray100,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child:
                                    TextField(
                                      onChanged:(e){
                                        setState(() {});
                                      },
                                      controller: messagecontroller,
                                      style: AppStyle.txtInter(size: 20),
                                      cursorColor: UIColors.cursorColor,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: 'Message ...',
                                        fillColor: UIColors.edittextFillColor,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(bottom: 20),
                                    child: IconButton(
                                      icon: Icon(CupertinoIcons.paperplane_fill,color: Theme.of(context).primaryColor,size: 24,),
                                      onPressed: () {
                                        setState(() {
                                          loadAnswer=true;
                                        });
                                        sendQuestion();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  String getDate(num time,{bool hh_mm=false,bool yy_mm=false}){
    if(hh_mm)
      return DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).format('kk:mm');
    if(yy_mm){
      var days=['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];
      var months=['Janvier','Fevrier','Mars','Avril','Mai','Juin','Juillet','Aout'
        ,'Septembre','Octobre','Novembre','Decembre'];
      String day = DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).day.toString();
      String dayCalendar = days[DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).weekday-1];
      String month = months[DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).month-1];
      String year = DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).year.toString();
      String date= dayCalendar+', '+day+' '+month+' '+year;
      return date;
    }
    String duree='';
    double actual=DateTime.now().millisecondsSinceEpoch/1000;
    double periode = actual-time;
    if(periode/3600<1)
      duree = (periode/60).floor().toString() + 'min';
    else if(periode/3600<24)
      duree = DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).format('kk:mm');
    else
      duree = DateTime.fromMillisecondsSinceEpoch(time.toInt()*1000).format('MM/dd');
    return duree;
  }

  String getDuration(int time){
    return DateTime.fromMillisecondsSinceEpoch(time).format('mm:ss');
  }

  load() async{
    user = await API.getUI_user();
    await API.createDiscussion().then((response) => {
      dev.log('Chatbot DEBUG: '+response.body),
      if(response.statusCode==200 || response.statusCode==201)
      {
        session = jsonDecode(response.body)['session_id'],
        messages.clear()
      }
      else{
        dev.log('Chatbot DEBUG: '+response.body),
        toast('Echec de la connexion au serveur !!',color: Colors.red)
      }
    }).onError((error, stackTrace) => {
      // dev.log('Chatbot DEBUG: '+stackTrace.toString()),
      toast('Echec de la connexion au serveur !!',color: Colors.red)
    });
    loading = false;
    setState(() {});
  }

  int getIndexOfmessage(String id){
    for(var i=0;i<messages.length;i++){
      if(messages[i].id==id)
        return i;
    }
    return -1;
  }


  sendQuestion() async {
    dev.log("DEBUG : "+user!.id);
    if(messagecontroller.text.isNotEmpty) {
      int time = (DateTime.now().millisecondsSinceEpoch /1000).floor();
      UIMessage message = UIMessage(
        id: (messages.length+1).toString(),
        sender: 'user',
        date_envoi: time,
        message: messagecontroller.text,
        session: session
      );
      messages.add(message);
      _observer.itemCount = messages.length;
      messagecontroller.clear();
      var aiResp=UIMessage();
      await API.askAI(message).then((response) => {
        dev.log('Chatbot DEBUG: '+response.body),
        if(response.statusCode==200 || response.statusCode==201){
          aiResp = UIMessage.fromJson(json.decode(response.body)),
          messages.add(aiResp),
        }
        else{
          dev.log('Chatbot DEBUG: '+response.body),
          toast('Echec de connexion au serveur !!',color: Colors.red)
        },
        setState(() {
          loadAnswer=false;
        })
      });
      scrollcontroller.scrollToIndex(messages.length-1, preferPosition: AutoScrollPosition.end,duration: Duration(milliseconds: 1000));
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        loadAnswer=false;
      });
    }
  }
  bool first=false;

}