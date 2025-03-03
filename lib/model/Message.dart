import 'dart:convert';

class UIMessage {
  String id;
  String session;
  String message;
  String sender;
  num date_envoi;

  UIMessage({
    this.id = "auto",
    this.session = "none",
    this.message = "",
    this.sender = "user",
    this.date_envoi = 0,
  });

  factory UIMessage.fromJson(Map<String, dynamic> json) {
    return UIMessage(
        id : json["id"].toString(),
        session : json["session"],
        sender : json["sender"],
        message : json["message"],
        // date_envoi : json["date_envoi"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'session_id' : session,
      'sender' : sender,
      'message' : message,
      'date_envoi' : date_envoi
    };
  }

  String toJson() {
    return json.encode(this.toMap());
  }

  }
