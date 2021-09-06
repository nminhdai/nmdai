import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Note {
  Note({
    @required this.title,
    this.uid,
    this.dateTime,
    this.description,
    this.from,
    this.to,
    this.backgroundColor,
    this.isAllDay,
  });
  final String title;
  final String uid;
  final Timestamp dateTime;
  final String description;
  final Timestamp from;
  final Timestamp to;
  final Color backgroundColor;
  final bool isAllDay;

  Note.fromJson(Map<String, Object> json)
      : this(
          title: json['title'] as String,
          uid: json['uid'] as String,
          dateTime: json['dateTime'] as Timestamp,
          description: json['description'] as String,
          from: json['from'] as Timestamp,
          to: json['to'] as Timestamp,
          backgroundColor: json['backgroundColor'] as Color,
          isAllDay: json['isAllDay'] as bool,
        );

  Map<String, Object> toJson() {
    return {
      'title': title,
      'uid': uid,
      'dateTime': dateTime,
      'description': description,
      'from': from,
      'to': to,
      'backgroundColor': backgroundColor,
      'isAllDay': isAllDay,
    };
  }
}
