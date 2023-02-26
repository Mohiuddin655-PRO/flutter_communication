import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart' as dio;

import '../../../../core/common/responses/response.dart';
import '../../../feature/domain/entities/base_entity.dart';
import 'data_source.dart';

abstract class ApiDataSource<T extends Entity> extends DataSource<T> {
  final Api api;
  final String path;

  ApiDataSource({
    required this.api,
    required this.path,
  });

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String currentSource<R>(
    R? Function(R parent)? source,
  ) {
    final reference = "${api.api}/$path";
    dynamic current = source?.call(reference as R);
    if (current is String) {
      return current;
    } else {
      return reference;
    }
  }

  String currentUrl<R>(String id, R? Function(R parent)? source) =>
      "${currentSource(source)}/$id";

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final url = id != null && id.isNotEmpty
          ? currentUrl(id, source)
          : currentSource(source);
      final reference = await database.post(url, data: data);
      final code = reference.statusCode;
      if (code == 200 || code == 201 || code == api.status.created) {
        final result = reference.data;
        log.put("Type", "INSERT").put("URL", url).put("RESULT", result).build();
        return response.copyWith(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        log.put("Type", "INSERT").put("URL", url).put("ERROR", error).build();
        return response.copyWith(snapshot: reference, message: error);
      }
    } else {
      final error = "Undefined data $data";
      log.put("Type", "INSERT").put("ERROR", error).build();
      return response.copyWith(message: error);
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
        final url = currentUrl(id, source);
        final reference = await database.put(url, data: data);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.updated) {
          final result = reference.data;
          log.put("Type", "GET").put("URL", url).put("RESULT", result).build();
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("Type", "UPDATE").put("URL", url).put("ERROR", error).build();
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined data $data";
        log.put("Type", "UPDATE").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "UPDATE").put("ERROR", _).build();
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
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        final reference = await database.delete(url);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.deleted) {
          final result = reference.data;
          log
              .put("Type", "DELETE")
              .put("URL", url)
              .put("RESULT", result)
              .build();
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("Type", "DELETE").put("URL", url).put("ERROR", error).build();
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        log.put("Type", "DELETE").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "DELETE").put("ERROR", _).build();
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
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is Map) {
          final result = build(data);
          log
              .put("Type", "GET")
              .put("URL", url)
              .put("RESULT", result.runtimeType)
              .build();
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("Type", "GET").put("URL", url).put("ERROR", error).build();
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        log.put("Type", "GET").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "GET").put("ERROR", _).build();
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
      final url = currentSource(source);
      final reference = await database.get(url);
      final data = reference.data;
      final code = reference.statusCode;
      if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
        List<T> result = data.map((item) {
          return build(item);
        }).toList();
        log
            .put("Type", "GETS")
            .put("URL", url)
            .put("SIZE", result.length)
            .put("RESULT", result.map((e) => e.runtimeType).toList())
            .build();
        return response.copyWith(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        log.put("TYPE", "GETS").put("URL", url).put("ERROR", error).build();
        return response.copyWith(snapshot: reference, message: error);
      }
    } catch (_) {
      log.put("TYPE", "GETS").put("ERROR", _).build();
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
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
          final reference = await database.get(url);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == api.status.ok) && data is Map) {
            final result = build(data);
            log.put("LIVE", "$url : $result");
            log
                .put("TYPE", "LIVE")
                .put("URL", url)
                .put("RESULT", result.runtimeType)
                .build();
            controller.add(
              response.copyWith(result: result),
            );
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log.put("TYPE", "LIVE").put("URL", url).put("ERROR", error).build();
            controller.addError(
              response.copyWith(snapshot: reference, message: error),
            );
          }
        });
      } else {
        final error = "Undefined ID [$id]";
        log.put("TYPE", "LIVE").put("ERROR", error).build();
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("TYPE", "LIVE").put("ERROR", _).build();
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
      final url = currentSource(source);
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
          List<T> result = data.map((item) {
            return build(item);
          }).toList();
          log
              .put("TYPE", "LIVES")
              .put("URL", url)
              .put("SIZE", result.length)
              .put("RESULT", result.map((e) => e.runtimeType).toList())
              .build();
          controller.add(
            response.copyWith(result: result),
          );
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("TYPE", "LIVES").put("ERROR", error).build();
          controller.addError(
            response.copyWith(snapshot: reference, message: error),
          );
        }
      });
    } catch (_) {
      log.put("TYPE", "LIVES").put("ERROR", _).build();
      controller.addError(_);
    }

    return controller.stream;
  }
}

class Api {
  final String api;
  final ApiStatus status;

  const Api({
    required this.api,
    this.status = const ApiStatus(),
  });
}

class ApiStatus {
  final int ok;
  final int canceled;
  final int created;
  final int updated;
  final int deleted;

  const ApiStatus({
    this.ok = 200,
    this.created = 201,
    this.updated = 202,
    this.deleted = 203,
    this.canceled = 204,
  });
}

enum ApiRequest { get, post }
