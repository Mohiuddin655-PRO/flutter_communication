import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BaseEntity extends Equatable {
  final String? noteId;
  final String? note;
  final Timestamp? time;
  final String? uid;

  const BaseEntity({
    this.noteId,
    this.note,
    this.time,
    this.uid,
  });

  @override
  List<Object?> get props => [noteId, note, time, uid];
}
