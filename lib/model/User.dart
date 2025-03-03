import 'dart:convert';


class User {
  String id;
  String nom;
  String prenom;
  String sexe;
  int date_naissance;
  String telephone;
  String email;
  String password;
  String photo;
  String type;

  User({
    this.id = "",
    this.nom = "none",
    this.prenom = "none",
    this.sexe = "none",
    this.date_naissance = 0,
    this.telephone = "none",
    this.email = "none",
    this.password = "none",
    this.photo = "none",
    this.type = "user",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id : json["id"],
        nom : json["last_name"]??'none',
        prenom : json["first_name"]??'none',
        email : json["email"]??'none',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'nom' : nom,
      'prenom' : prenom,
      'sexe' : sexe,
      'date_naissance' : date_naissance,
      'telephone' : telephone,
      'email' : email,
      'photo' : photo,
      'type' : type,
    };
  }

  Map<String, dynamic> toMap2() {
    return {
      'id' : id,
      'nom' : nom,
      'prenom' : prenom,
      'sexe' : sexe,
      'date_naissance' : date_naissance,
      'telephone' : telephone,
      'email' : email,
      'password' : password,
      'photo' : photo,
      'type' : type,
    };
  }

  String toJson() {
    return json.encode(this.toMap());
  }

  String toJson2() {
    return json.encode(this.toMap2());
  }
}
