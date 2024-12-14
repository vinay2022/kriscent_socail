// To parse this JSON data, do
//
//     final reelModel = reelModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReelModel reelModelFromJson(String str) => ReelModel.fromJson(json.decode(str));

String reelModelToJson(ReelModel data) => json.encode(data.toJson());

class ReelModel {
  String? id;
  String? title;
  String? caption;
  String? video;
  String? photo;

  String? authorId;
  List<String>? likesIds;
  int? numberOfComments;
  int? numberOfLikes;
  List<Comment>? comments;

  ReelModel({
    this.id,
    this.title,
    this.caption,
    this.video,
    this.photo,
    this.authorId,
    this.likesIds,
    this.numberOfComments,
    this.numberOfLikes,
    this.comments,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) => ReelModel(
    id: json["id"],
    title: json["title"],
    caption: json["caption"],
    video: json["video"],
    photo: json["photo"],
    authorId: json["authorId"],
    likesIds: json["likes_ids"] == null ? [] : List<String>.from(json["likes_ids"]!.map((x) => x)),
    numberOfComments: json["number_of_comments"],
    numberOfLikes: json["number_of_likes"],
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "caption": caption,
    "video": video,
    "photo": photo,
    "authorId": authorId,
    "likes_ids": likesIds == null ? [] : List<dynamic>.from(likesIds!.map((x) => x)),
    "number_of_comments": numberOfComments,
    "number_of_likes": numberOfLikes,
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  String? commentId;
  String? text;
  String? commentAuthorId;
  DateTime? createdAt;

  Comment({
    this.commentId,
    this.text,
    this.commentAuthorId,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json["comment_Id"],
    text: json["text"],
    commentAuthorId: json["comment_author_id"],
    createdAt: json["created_at"] == null ? null : (json['created_at'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    "comment_Id": commentId,
    "text": text,
    "comment_author_id": commentAuthorId,
    "created_at": Timestamp.fromDate(createdAt ?? DateTime.now()),
  };
}
