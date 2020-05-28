import 'package:flutter/material.dart';

class Section {
  Section({
    this.backgroundColor,
    this.textColor,
    this.title,
    this.text,
    this.imagePath,
    this.subTitle,
    this.type,
    this.fontSize,
    this.familyName,
    this.borderColor,
    this.borderWidth,
    this.isEditing,
  });

  //反序列化
  Section.from(Map map){
    //String
    title = map['title'];
    subTitle = map['subTitle'];
    text = map['text'];
    imagePath = map['imagePath'];
    backgroundColor = map["backgroundColor"] != null ? Color( map["backgroundColor"]):null;
    textColor =map["textColor"] != null ? Color(map["textColor"]):null;
    borderColor = map["borderColor"] != null ? Color(map["borderColor"]) : null;
    borderWidth =  map["borderWidth"];
    fontSize =  map["fontSize"];
    familyName =  map["familyName"];
    type = SectionType.values[map['type']];
  }

  //序列化
  Map toJson() {
    Map map = Map();
    map["title"] = this.title;
    map["subTitle"] = this.subTitle;
    map["text"] = this.text;
    map["imagePath"] = this.imagePath;
    map["backgroundColor"] = this.backgroundColor?.value ?? null;
    map["textColor"] = this.textColor?.value ?? null;
    map["borderColor"] = this.borderColor?.value ?? null;
    map["borderWidth"] = this.borderWidth;
    map["fontSize"] = this.fontSize;
    map["familyName"] = this.familyName;
    map["type"] = this.type.index;
    return map;
  }

  Section copyWith({
    Color backgroundColor,

    Color textColor,

    String title,

    String subTitle,

    String text,

    SectionType type,

    double fontSize,

    String familyName,

    Color borderColor,

    double borderWidth,

    bool isEditing,

    String imagePath,
  }){
    return Section(
      backgroundColor:backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      text:  text ?? this.text,
      type: type ?? this.type,
      fontSize:  fontSize ?? this.fontSize,
      familyName: familyName ?? this.familyName,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      isEditing: isEditing ?? this.isEditing,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Color backgroundColor;

  Color textColor;

  String title;

  String subTitle;

  String text;

  SectionType type;

  double fontSize;

  String familyName;

  Color borderColor;

  double borderWidth;

  bool isEditing;

  String imagePath;



}

enum SectionType {
  firstTitle,
  title,
  text,
  image,
  line,
}
