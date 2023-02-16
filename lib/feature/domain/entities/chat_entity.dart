import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

class ChatEntity extends Entity {
  final ChattingType type;
  final List<MessageEntity> messages;

  const ChatEntity({
    super.id = "",
    super.time,
    this.type = ChattingType.none,
    this.messages = const [],
  });

  ChatEntity copyWith({
    String? id,
    int? time,
    ChattingType? type,
    List<MessageEntity>? messages,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      time: time ?? this.time,
      type: type ?? this.type,
      messages: messages ?? this.messages,
    );
  }

  factory ChatEntity.from(dynamic data) {
    dynamic id, time;
    dynamic type;
    dynamic messages;
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        time = data.child('time');
        type = data.child('type');
        messages = data.child('messages');
      } else {
        id = data['id'];
        time = data['time'];
        type = data['type'];
        messages = data['messages'];
      }
    } catch (e) {
      log(e.toString());
    }
    final List<MessageEntity> list = [];
    if (messages is Map){
      messages.forEach((key, value) {
        if (value is Map){
          list.add(MessageEntity.from(value));
        }
      });
    }
    return ChatEntity(
      id: id is String ? id : "",
      time: time is int ? time : 0,
      type: ChattingType.from(type),
      messages: list,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time": time,
      "type": type,
      "messages": messages,
    };
  }

  @override
  List<Object?> get props => [
        id,
        time,
        type,
        messages,
      ];
}

enum ChattingType {
  none,
  inbox,
  group;
  
  factory ChattingType.from (dynamic type){
    final name = "$type";
    if (name == ChattingType.group.name){
      return ChattingType.group;
    } else if (name == ChattingType.inbox.name){
      return ChattingType.inbox;
    } else {
      return ChattingType.none;
    }
  }
}

