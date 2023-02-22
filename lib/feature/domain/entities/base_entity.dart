import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

abstract class Entity extends Equatable {
  final String id;
  final int timeMS;

  const Entity({
    required String? id,
    int? timeMS,
  })  : id = id ?? "",
        timeMS = timeMS ?? 0;

  Map<String, dynamic> get source;

  static String get key => timeMills.toString();

  static int get timeMills => DateTime.now().millisecondsSinceEpoch;

  String get time {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMS);
    return DateFormat("hh:mm a").format(date);
  }

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMS);
    return DateFormat("MMM dd, yyyy").format(date);
  }

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
