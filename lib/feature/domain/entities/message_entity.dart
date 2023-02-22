import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

class MessageEntity extends Entity {
  final bool isSeen;
  final String message;
  final String photo;
  final String sender;
  final List<String> views;

  const MessageEntity({
    super.id = "",
    super.timeMS,
    this.isSeen = false,
    this.photo = "",
    this.message = "",
    this.sender = "",
    this.views = const [],
  });

  MessageEntity copyWith({
    String? id,
    int? timeMS,
    bool? isSeen,
    String? message,
    String? photo,
    String? sender,
    List<String>? views,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      timeMS: timeMS ?? this.timeMS,
      isSeen: isSeen ?? this.isSeen,
      message: message ?? this.message,
      photo: photo ?? this.photo,
      sender: sender ?? this.sender,
      views: views ?? this.views,
    );
  }

  factory MessageEntity.from(dynamic data) {
    dynamic id, timeMS;
    dynamic seen;
    dynamic message, photo;
    dynamic sender;
    dynamic views;
    List<String> list = [];
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        timeMS = data.child('time_mills');
        seen = data.child('seen');
        message = data.child('message');
        photo = data.child('photo');
        sender = data.child('sender');
        views = data.child('views');
      } else {
        id = data['id'];
        timeMS = data['time_mills'];
        seen = data['seen'];
        message = data['message'];
        photo = data['photo'];
        sender = data['sender'];
        views = data['views'];
      }
    } catch (e) {
      log(e.toString());
    }
    list = views is List ? views.map((e) => e.toString()).toList() : <String>[];
    return MessageEntity(
      id: id is String ? id : "",
      timeMS: timeMS is int ? timeMS : 0,
      isSeen: seen is bool ? seen : false,
      photo: photo is String ? photo : "",
      message: message is String ? message : "",
      sender: sender is String ? sender : "",
      views: list,
    );
  }

  bool get isCurrentUid => AuthHelper.uid == sender;

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMS,
      "seen": isSeen,
      "message": message,
      "photo": photo,
      "sender": sender,
      "views": views,
    };
  }

  @override
  List<Object?> get props => [
        id,
        timeMS,
        isSeen,
        photo,
        message,
        sender,
        views,
      ];
}

class Sender {
  final String? id;
  final String? name;
  final String? photo;

  const Sender({
    this.id = "",
    this.name,
    this.photo,
  });

  Map<String, dynamic> get source {
    return {
      "id": id,
      "name": name,
      "photo": photo,
    };
  }

  factory Sender.from(Map<String, dynamic>? source) {
    final data = source ?? {};
    dynamic id = data["id"];
    dynamic name = data["name"];
    dynamic photo = data["photo"];
    return Sender(
      id: id is String ? id : "",
      name: name is String ? name : "",
      photo: photo is String ? photo : "",
    );
  }
}
