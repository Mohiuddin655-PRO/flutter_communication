import 'package:equatable/equatable.dart';

class Entity extends Equatable {
  final String id;
  final String? uid;
  final int? time;

  const Entity({
    required this.id,
    this.uid,
    this.time,
  });

  @override
  List<Object?> get props => [id, uid, time];
}
