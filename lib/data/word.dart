// To parse this JSON data, do
//
//     final word = wordFromJson(jsonString);

import 'dart:convert';

Word wordFromJson(String str) {
  final jsonData = json.decode(str);
  return Word.fromJson(jsonData);
}

String wordToJson(Word data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Word {
  String wordTitle;
  String wordDefinition;

  Word(
    this.wordTitle,
    this.wordDefinition,
  );

  factory Word.fromJson(Map<String, dynamic> json) => new Word(
    json["word_name"],
    json["word_definition"],
  );

  Map<String, dynamic> toJson() => {
    "word_name": wordTitle,
    "word_definition": wordDefinition,
  };
}