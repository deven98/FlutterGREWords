// To parse this JSON data, do
//
//     final essayModel = essayModelFromJson(jsonString);

import 'dart:convert';

//EssayModel essayModelFromJson(String str) => EssayModel.fromJson(json.decode(str));

String essayModelToJson(EssayModel data) => json.encode(data.toJson());

class EssayModel {
  String question;
  String type;
  String text;
  bool public;
  String uid;
  int timestamp;
  String id;

  EssayModel({
    this.question,
    this.type,
    this.text,
    this.public,
    this.uid,
    this.timestamp,
    this.id,
  });

  factory EssayModel.fromJson(Map<String, dynamic> json, String id) =>
      EssayModel(
        question: json["question"] == null ? null : json["question"],
        type: json["type"] == null ? null : json["type"],
        text: json["text"] == null ? null : json["text"],
        public: json["public"] == null ? null : json["public"],
        uid: json["uid"] == null ? null : json["uid"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        id: id,
      );

  Map<String, dynamic> toJson() => {
        "question": question == null ? null : question,
        "type": type == null ? null : type,
        "text": text == null ? null : text,
        "public": public == null ? null : public,
        "uid": uid == null ? null : uid,
        "timestamp": timestamp == null ? null : timestamp,
      };
}
