import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final String id;
  final int time;

  const Entity({
    required String? id,
    int? time,
  })  : id = id ?? "",
        time = time ?? 0;

  Map<String, dynamic> get source;

  static String get key => timeMills.toString();

  static int get timeMills => DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() => source.toString();
}

extension StringValidator on String? {
  bool get isValid {
    return (this ?? "").isNotEmpty;
  }
}

extension NumValidator on num? {
  bool get isValid {
    return (this ?? 0) > 0;
  }
}
