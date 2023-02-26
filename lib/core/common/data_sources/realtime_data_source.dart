import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/common/responses/response.dart';
import '../../../feature/domain/entities/base_entity.dart';
import 'data_source.dart';

abstract class RealtimeDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  RealtimeDataSource({required this.path});

  FirebaseDatabase? _db;

  FirebaseDatabase get database => _db ??= FirebaseDatabase.instance;

  DatabaseReference _source<R>(
    R? Function(R parent)? source,
  ) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if ((id ?? "").isNotEmpty) {
      final ref = _source(source).child(id ?? "");
      return await ref.get().then((value) async {
        if (!value.exists) {
          await ref.set(data);
          return response.copyWith(result: data);
        } else {
          log.put("INSERT", value);
          return response.copyWith(
              snapshot: value, message: 'Already inserted!');
        }
      });
    } else {
      return response.copyWith(message: "ID isn't valid!");
    }
  }

  @override
  Future<Response> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      await _source(source).child(id).update(data);
      return response.copyWith(result: true);
    } catch (_) {
      log.put("UPDATE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      await _source(source).child(id).remove();
      return response.copyWith(result: true);
    } catch (_) {
      log.put("DELETE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).child(id).get();
      log.put("GET", result);
      if (result.exists && result.value != null) {
        return response.copyWith(result: build(result.value));
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } catch (_) {
      log.put("GET", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<List<T>>();
    try {
      final result = await _source(source).get();
      log.put("GETS", result);
      if (result.exists) {
        List<T> list = result.children.map((e) {
          return build(e.value);
        }).toList();
        return response.copyWith(result: list);
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } catch (_) {
      log.put("GETS", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    return gets(
      onlyUpdatedData: true,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).child(id).onValue.listen((event) {
        log.put("GET", event);
        if (event.snapshot.exists || event.snapshot.value != null) {
          controller
              .add(response.copyWith(result: build(event.snapshot.value)));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      log.put("GET", _.toString());
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<List<T>>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      _source(source).onValue.listen((result) {
        log.put("GETS", result);
        if (result.snapshot.exists) {
          List<T> list = result.snapshot.children.map((e) {
            return build(e.value);
          }).toList();
          controller.add(response.copyWith(result: list));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      log.put("GETS", _.toString());
      controller.addError(_);
    }

    return controller.stream;
  }
}
