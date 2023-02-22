import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

class RoomEntity extends Entity {
  final String contributor;
  final String owner;
  final ChattingType type;
  final MessageEntity recent;

  const RoomEntity({
    super.id = "",
    super.timeMS,
    this.contributor = "",
    this.owner = "",
    this.type = ChattingType.none,
    this.recent = const MessageEntity(),
  });

  RoomEntity copyWith({
    String? id,
    int? timeMS,
    String? owner,
    String? contributor,
    ChattingType? type,
    MessageEntity? recent,
    List<String>? views,
  }) {
    return RoomEntity(
      id: id ?? this.id,
      timeMS: timeMS ?? this.timeMS,
      owner: owner ?? this.owner,
      contributor: contributor ?? this.contributor,
      type: type ?? this.type,
      recent: recent ?? this.recent,
    );
  }

  factory RoomEntity.from(dynamic data) {
    dynamic id, timeMS;
    dynamic type;
    dynamic recent, owner, contributor;
    try {
      if (data is DataSnapshot) {
        id = data.child('id');
        timeMS = data.child('time_mills');
        owner = data.child('owner');
        contributor = data.child('contributor');
        type = data.child('type');
        recent = data.child('recent');
      } else {
        id = data['id'];
        timeMS = data['time_mills'];
        owner = data['owner'];
        contributor = data['contributor'];
        type = data['type'];
        recent = data['recent'];
      }
    } catch (e) {
      log(e.toString());
    }
    return RoomEntity(
      id: id is String ? id : "",
      timeMS: timeMS is int ? timeMS : 0,
      owner: owner is String ? owner : "",
      contributor: contributor is String ? contributor : "",
      type: ChattingType.from(type),
      recent: MessageEntity.from(recent),
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMS,
      "type": type.name,
      "owner": owner,
      "contributor": contributor,
      "recent": recent.source,
    };
  }

  @override
  List<Object?> get props => [
        id,
        timeMS,
        type.name,
        recent.source,
        owner,
        contributor,
      ];
}

enum ChattingType {
  none,
  inbox,
  group;

  factory ChattingType.from(dynamic type) {
    final name = "$type";
    if (name == ChattingType.group.name) {
      return ChattingType.group;
    } else if (name == ChattingType.inbox.name) {
      return ChattingType.inbox;
    } else {
      return ChattingType.none;
    }
  }
}

class RoomKeys {
  static const String recent = "recent";
  static const String contributor = "contributor";
  static const String owner = "owner";
  static const String type = "type";
}
