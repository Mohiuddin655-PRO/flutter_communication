import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

class MessageEntity extends Entity {
  final String? message;
  final String? photo;
  final String? userName;
  final String? userPhoto;

  const MessageEntity({
    super.id = "",
    super.uid,
    super.time,
    this.photo,
    this.message,
    this.userName,
    this.userPhoto,
  });

  MessageEntity copyWith({
    String? id,
    String? uid,
    int? time,
    String? message,
    String? photo,
    String? userName,
    String? userPhoto,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      time: time ?? this.time,
      message: message ?? this.message,
      photo: photo ?? this.photo,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }

  factory MessageEntity.from(dynamic data) {
    dynamic id, uid, time;
    dynamic message, photo;
    dynamic userName, userPhoto;
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        uid = data.child('uid');
        time = data.child('time');
        message = data.child('message');
        photo = data.child('photo');
        userName = data.child('user_name');
        userPhoto = data.child('user_photo');
      } else {
        id = data['id'];
        uid = data['uid'];
        time = data['time'];
        message = data['message'];
        photo = data['photo'];
        userPhoto = data['user_photo'];
        userName = data['user_name'];
      }
    } catch (e) {
      log(e.toString());
    }
    return MessageEntity(
      id: id,
      uid: uid,
      time: time,
      photo: photo,
      message: message,
      userName: userName,
      userPhoto: userPhoto,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "uid": uid,
      "time": time,
      "message": message,
      "photo": photo,
      "user_name": userName,
      "user_photo": userPhoto,
    };
  }

  @override
  List<Object?> get props => [
        id,
        uid,
        time,
        photo,
        message,
        userName,
        userPhoto,
      ];
}
