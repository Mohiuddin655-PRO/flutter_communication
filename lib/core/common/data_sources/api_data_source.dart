import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../../../core/common/responses/response.dart';
import 'data_source.dart';

abstract class ApiDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  ApiDataSource({required this.path});

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  dio.Dio _source<R>(
    R? Function(R parent)? source,
  ) {
    dynamic current = source?.call(database as R);
    if (current is dio.Dio) {
      return current;
    } else {
      return database;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response> insert<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final reference = await _source(source).put(path, data: data);
      if (reference.statusCode == 200) {
        return response.copyWith(result: reference.data);
      } else {
        return response.copyWith(
            snapshot: reference, message: "Data unmodified!");
      }
    } else {
      return response.copyWith(message: "Id isn't valid!");
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
      if (data.isNotEmpty) {
        final reference = await _source(source).post(path, data: data);
        if (reference.statusCode == 200) {
          return response.copyWith(result: reference.data);
        } else {
          return response.copyWith(
            snapshot: reference,
            message: "Data unmodified!",
          );
        }
      } else {
        return response.copyWith(
          message: "Id isn't valid!",
        );
      }
    } catch (_) {
      log.put("UPDATE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      if (id.isNotEmpty) {
        final reference = await _source(source).delete(path, data: id);
        if (reference.statusCode == 200) {
          return response.copyWith(result: reference.data);
        } else {
          return response.copyWith(
            snapshot: reference,
            message: "Data unmodified!",
          );
        }
      } else {
        return response.copyWith(
          message: "Id isn't valid!",
        );
      }
    } catch (_) {
      log.put("DELETE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        final reference = await _source(source).get(path, data: id);
        if (reference.statusCode == 200) {
          return response.copyWith(result: reference.data);
        } else {
          return response.copyWith(
            snapshot: reference,
            message: "Data unmodified!",
          );
        }
      } else {
        return response.copyWith(
          message: "Id isn't valid!",
        );
      }
    } catch (_) {
      log.put("GET", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets<R>({
    bool onlyUpdatedData = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<List<T>>();
    try {
      final reference = await _source(source).post(path);
      if (reference.statusCode == 200) {
        return response.copyWith(result: reference.data);
      } else {
        return response.copyWith(
          snapshot: reference,
          message: "Data unmodified!",
        );
      }
    } catch (_) {
      log.put("GETS", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates<R>({
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
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
        if (id.isNotEmpty) {
          final reference = await _source(source).get(path, data: id);
          if (reference.statusCode == 200) {
            controller.add(response.copyWith(result: build(reference.data)));
          } else {
            controller.addError(response.copyWith(
              snapshot: reference,
              message: "Data unmodified!",
            ));
          }
        } else {
          controller.addError(response.copyWith(
            message: "Id isn't valid!",
          ));
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
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
        final reference = await _source(source).get(path);
        if (reference.statusCode == 200) {
          if (onlyUpdatedData) {
            List<T> list = reference.data.map((e) {
              return build(e.doc.data());
            }).toList();
            controller.add(response.copyWith(result: list));
          } else {
            List<T> list = reference.data.map((e) {
              return build(e.data());
            }).toList();
            controller.add(response.copyWith(result: list));
          }
        } else {
          controller.addError(response.copyWith(
            snapshot: reference,
            message: "Data unmodified!",
          ));
        }
      });
    } catch (_) {
      log.put("GETS", _.toString());
      controller.addError(_);
    }

    return controller.stream;
  }
}
