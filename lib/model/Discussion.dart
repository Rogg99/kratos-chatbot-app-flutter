import 'dart:convert';

class Discussion {
  String id;
  String title;
  num last_date;

  Discussion({
    this.id = "auto",
    this.last_date = 0,
    this.title = "none",
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
        id : json["id"],
        last_date : json["last_date"],
        title : json["title"]
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'last_date' : last_date,
      'title' : title
    };
  }
  String toJson() {
    return json.encode(this.toMap());
  }
  }
