import 'package:equatable/equatable.dart';

abstract class Entity<T> extends Equatable {
  final String? id;
  final String? uid;
  final int? time;

  const Entity({
    required this.id,
    this.uid,
    this.time,
  });

  Map<String, dynamic> get source;

  @override
  List<Object?> get props => [id, uid, time];

  @override
  String toString() => source.toString();
}
