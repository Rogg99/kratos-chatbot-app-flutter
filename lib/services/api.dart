import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:chatbot_app/core/colors/colors.dart';
import 'package:chatbot_app/core/fonctions.dart';
import 'package:chatbot_app/core/theming/app_style.dart';
import 'package:chatbot_app/model/Discussion.dart';
import 'package:chatbot_app/model/Message.dart';
import 'package:chatbot_app/model/Token.dart';
import 'package:chatbot_app/model/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


class Api {
  String Api_ = '192.168.1.162:7898/chatbot/api/v1/chat/'; // The Chatbot API BASE URL
  String userApi_ = "https://192.168.1.162:454/kratos-payment/api/v1/auth";  // The Payment Athentication API BASE URL
  late String authorization = "Bearer ";


  Future<http.Response> signup(User user) async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    http.Client client = IOClient(httpClient);

    var url = Uri.parse('$userApi_/register/');

    log(url.toString());
    var body = json.encode({
      "email": user.email, 
      "password": user.password,
      "first_name": user.prenom,
      "last_name": user.nom,
      });
    var headers = {"Content-Type": "application/json"};

    return client.post(url, headers: headers, body: body).then((http.Response response) {
      return response;
    });
  }

  Future<http.Response> login(String email, String password) async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    http.Client client = IOClient(httpClient);

    var url = Uri.parse('$userApi_/login/');
    log(url.toString());

    var body = json.encode({"username": email, "password": password});
    log(body.toString());

    var headers = {
      "Content-Type" : "application/json",
    };

    return client.post(url, headers: headers, body: body).then((http.Response response) {
      return response;
    });

  }

  Future<http.Response> getProfile() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    http.Client client = IOClient(httpClient);

    authorization = await getToken().then((value) =>
      'Bearer ' + value!.access
    );
    var url=Uri.parse('$userApi_/profile/');
    log(url.toString());
    var headers = {"Content-Type": "application/json", "Authorization": authorization};
    return client.get(
      url,
      headers: headers,
    ).then((http.Response response) {
      return response;
    });
  }

  Future<http.Response> askAI(UIMessage message) async {
    authorization = await getToken().then((value) =>
      'Bearer ' + value!.access
    );
    var body = message.toJson();
    log(body.toString());
    var url = Uri.parse('http://$Api_'+'send-message/');
    var headers = {"Content-Type": "application/json", "Authorization": authorization};
    return http.post(url, headers: headers, body: body).then((http.Response response) {
      return response;
    });
  }

  Future<http.Response> createDiscussion() async {
    authorization = await getToken().then((value) =>
    'Bearer ' + value!.access
    );
    var url = Uri.parse('http://$Api_'+'start-session/');
    // var url = Uri.http('$Api_', 'start-session/');
    var headers = {"Content-Type": "application/json", "Authorization": authorization};

    return http.post(url, headers: headers).then((http.Response response) {
      return response;
    });
  }

  Future<bool> verifyConnexionStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Timer> keepTokenAlive({bool force = false}) async {
    Token token;
    log('DEBUG Chatbot: keeping Token Alive');
    try {
      token = await getKey('token').then((value) => Token.fromJson(jsonDecode(value)));
      int duration = 0;
      if (!force) duration = (token.time - DateTime.now().millisecondsSinceEpoch / 1000).floor() - 10;
      Timer timer = Timer(Duration(seconds: duration), () {
        login(token.email, token.password).then((resp) async => {
              if (resp.statusCode == 200)
                {
                  duration = 3600,
                  token.access = Token.fromJson2(jsonDecode(resp.body)).access,
                  token.refresh = Token.fromJson2(jsonDecode(resp.body)).refresh,
                  token.time = 24 * 3600 + DateTime.now().millisecondsSinceEpoch / 1000,
                  await saveKey('token', jsonEncode(token.toMap())),
                  // log(token),
                  Timer.periodic(Duration(seconds: duration), (Timer timer) {
                    log('DEBUG Chatbot: keeping Token Alive for 1 day');
                    login(token.email, token.password).then((resp) async => {
                          if (resp.statusCode == 200)
                            {
                              duration = 3600,
                              token.access = Token.fromJson2(jsonDecode(resp.body)).access,
                              token.refresh = Token.fromJson2(jsonDecode(resp.body)).refresh,
                              token.time = 24 * 3600 + DateTime.now().millisecondsSinceEpoch / 1000,
                              await saveKey('token', jsonEncode(token.toMap())),
                              log('DEBUG Chatbot: token refreshed successfully for 24 hours next refresh time on : ' +
                                  token.time.toString()),
                            }
                        });
                  }),
                }
            });
      });
      return timer;
    } on Exception catch (error) {
        print(error.toString());
        log('DEBUG Chatbot : No token stored in local database');
    }
    return Timer(Duration(seconds: 0), () {});
  }

  Future<void> clearUserDatas() async {
    log('deleting user datas...');
    saveKey('user', '');
    saveKey('token','');
    log('deleting user datas finished with');
  }

  Future<User> getUI_user()async{
    return User.fromJson(jsonDecode(await getKey('user')));
  }

  Future<Token?> getToken()async{
    try{
      return Token.fromJson(jsonDecode(await getKey('token')));
    }catch (_){
      return null;
    }
    // print(getKey('token'));
  }
}
