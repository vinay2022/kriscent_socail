// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  List<String>? followers;
  List<String>? following;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.followers,
    this.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profileImage: json["profile_image"],
    followers: json["followers"] == null ? [] : List<String>.from(json["followers"]!.map((x) => x)),
    following: json["following"] == null ? [] : List<String>.from(json["following"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "profile_image": profileImage,
    "followers": followers == null ? [] : List<dynamic>.from(followers!.map((x) => x)),
    "following": following == null ? [] : List<dynamic>.from(following!.map((x) => x)),
  };
}
