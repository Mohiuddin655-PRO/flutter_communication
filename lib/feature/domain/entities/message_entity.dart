import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

class MessageEntity extends Entity {
  final String? message;
  final String? photo;
  final MessagingUser sender;
  final MessagingUser receiver;

  const MessageEntity({
    super.id = "",
    super.uid,
    super.time,
    this.photo,
    this.message,
    this.sender = const MessagingUser(),
    this.receiver = const MessagingUser(),
  });

  MessageEntity copyWith({
    String? id,
    String? uid,
    int? time,
    String? message,
    String? photo,
    MessagingUser? sender,
    MessagingUser? receiver,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      time: time ?? this.time,
      message: message ?? this.message,
      photo: photo ?? this.photo,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
    );
  }

  factory MessageEntity.from(dynamic data) {
    dynamic id, uid, time;
    dynamic message, photo;
    dynamic sender, receiver;
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        uid = data.child('uid');
        time = data.child('time');
        message = data.child('message');
        photo = data.child('photo');
        sender = data.child('sender');
        receiver = data.child('receiver');
      } else {
        id = data['id'];
        uid = data['uid'];
        time = data['time'];
        message = data['message'];
        photo = data['photo'];
        sender = data['sender'];
        receiver = data['receiver'];
      }
    } catch (e) {
      log(e.toString());
    }
    return MessageEntity(
      id: id ?? "",
      uid: uid ?? "",
      time: time ?? 0,
      photo: photo ?? "",
      message: message ?? "",
      sender: MessagingUser.from(sender),
      receiver: MessagingUser.from(receiver),
    );
  }

  bool get isCurrentUser => AuthHelper.uid == sender.id;

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "uid": uid,
      "time": time,
      "message": message,
      "photo": photo,
      "sender": sender.source,
      "receiver": receiver.source,
    };
  }

  @override
  List<Object?> get props => [
        id,
        uid,
        time,
        photo,
        message,
        sender,
        receiver,
      ];
}

class MessagingUser {
  final String id;
  final String? name;
  final String? photo;

  const MessagingUser({
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

  factory MessagingUser.from(Map<String, dynamic>? source) {
    final data = source ?? {};
    dynamic id = data["id"];
    dynamic name = data["name"];
    dynamic photo = data["photo"];
    return MessagingUser(
      id: id ?? "",
      name: name,
      photo: photo,
    );
  }
}
