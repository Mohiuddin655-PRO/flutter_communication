import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart' as dio;
import '../../../../core/common/responses/response.dart';
import '../../../feature/domain/entities/base_entity.dart';
import 'data_source.dart';

abstract class ApiDataSource<T extends Entity> extends DataSource<T> {
  final String api;
  final String path;

  ApiDataSource({
    required this.path,
    required this.api,
  });

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String _source<R>(
    R? Function(R parent)? source,
  ) {
    final reference = "$api/$path";
    dynamic current = source?.call(reference as R);
    if (current is String) {
      return current;
    } else {
      return reference;
    }
  }

  String _url<R>(String id, R? Function(R parent)? source) =>
      "${_source(source)}/$id";

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final url =
          id != null && id.isNotEmpty ? _url(id, source) : _source(source);
      final reference = await database.post(url, data: data);
      if (reference.statusCode == 200 || reference.statusCode == 201) {
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
        final reference = await database.put(_url(id, source), data: data);
        if (reference.statusCode == 200 || reference.statusCode == 201) {
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
        final reference = await database.delete(_url(id, source));
        if (reference.statusCode == 200 || reference.statusCode == 201) {
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
        final reference = await database.get(_url(id, source));
        final data = reference.data;
        if (reference.statusCode == 200 && data is Map) {
          return response.copyWith(result: build(data));
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
      final reference = await database.get(_source(source));
      final data = reference.data;
      if (reference.statusCode == 200 && data is List<dynamic>) {
        List<T> list = data.map((item) {
          return build(item);
        }).toList();
        return response.copyWith(result: list);
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
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        if (id.isNotEmpty) {
          final reference = await database.get(_url(id, source));
          final data = reference.data;
          if (reference.statusCode == 200 && data is Map) {
            controller.add(response.copyWith(result: build(data)));
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
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        print("Lives [${_source(source)}]");
        final reference = await database.get(_source(source));
        print("Lives [${_source(source)}] : $reference");
        final data = reference.data;
        print("Lives [${_source(source)}] : ${reference.statusCode}");
        if (reference.statusCode == 200 && data is List<dynamic>) {
          print("Lives [${_source(source)}] : $data");
          List<T> list = data.map((item) {
            return build(item);
          }).toList();
          controller.add(response.copyWith(result: list));
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
