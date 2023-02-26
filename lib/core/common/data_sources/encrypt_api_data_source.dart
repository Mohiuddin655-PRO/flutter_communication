import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';

import '../../../../core/common/responses/response.dart';
import '../../../feature/domain/entities/base_entity.dart';
import 'api_data_source.dart';

abstract class EncryptApiDataSource<T extends Entity> extends ApiDataSource<T> {
  final EncryptedApi encryptor;

  EncryptApiDataSource({
    required super.path,
    required this.encryptor,
  }) : super(api: encryptor);

  Future<Map<String, dynamic>> input(Map<String, dynamic>? data) async =>
      encryptor.input(data ?? {});

  Future<Map<String, dynamic>> output(String data) async =>
      encryptor.output(data);

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final value = await input(data);
      if (value.isNotEmpty) {
        final url = id != null && id.isNotEmpty
            ? currentUrl(id, source)
            : currentSource(source);
        final reference = await database.post(url, data: value);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == encryptor.status.created) {
          final result = reference.data;
          log
              .put("Type", "INSERT")
              .put("URL", url)
              .put("RESULT", result)
              .build();
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("Type", "INSERT").put("URL", url).put("ERROR", error).build();
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        const error = "Unacceptable request!";
        log.put("Type", "INSERT").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } else {
      const error = "Undefined data!";
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
        final value = await input(data);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.put(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.updated) {
            final result = reference.data;
            log
                .put("Type", "GET")
                .put("URL", url)
                .put("RESULT", result)
                .build();
            return response.copyWith(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log
                .put("Type", "UPDATE")
                .put("URL", url)
                .put("ERROR", error)
                .build();
            return response.copyWith(snapshot: reference, message: error);
          }
        } else {
          const error = "Unacceptable request!";
          log.put("Type", "UPDATE").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined data!";
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
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.delete(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.deleted) {
            final result = reference.data;
            log
                .put("Type", "DELETE")
                .put("URL", url)
                .put("RESULT", result)
                .build();
            return response.copyWith(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log
                .put("Type", "DELETE")
                .put("URL", url)
                .put("ERROR", error)
                .build();
            return response.copyWith(snapshot: reference, message: error);
          }
        } else {
          const error = "Unacceptable request!";
          log.put("Type", "DELETE").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined request!";
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
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = encryptor.type == ApiRequest.get
              ? await database.get(url, data: value)
              : await database.post(url, data: value);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == encryptor.status.ok) &&
              data is Map<String, dynamic>) {
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
          const error = "Unacceptable request.";
          log.put("Type", "GET").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined request.";
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
      final value = await input(extra);
      if (value.isNotEmpty) {
        final url = currentSource(source);
        final reference = encryptor.type == ApiRequest.get
            ? await database.get(url, data: value)
            : await database.post(url, data: value);
        final code = reference.statusCode;
        if (code == 200 || code == encryptor.status.ok) {
          final data = await encryptor.output(reference.data);
          if (data is Map<String, dynamic> || data is List<dynamic>) {
            List<T> result = [];
            if (data is Map) {
              result = [build(data)];
            } else {
              result = data.map((item) {
                return build(item);
              }).toList();
            }
            log
                .put("Type", "GETS")
                .put("URL", url)
                .put("SIZE", result.length)
                .put("RESULT", result.map((e) => e.runtimeType).toList())
                .build();
            return response.copyWith(result: result);
          } else {
            const error = "Data unmodified!";
            log
                .put("Type", "GET")
                .put("URL", url)
                .put("ERROR", error)
                .put("SOURCE", data.runtimeType)
                .build();
            return response.copyWith(snapshot: data, message: error);
          }
        } else {
          final error = "Unacceptable response [${reference.statusCode}]";
          log
              .put("TYPE", "GETS")
              .put("ERROR", error)
              .put("RESPONSE", reference.data)
              .build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Unacceptable request!";
        log.put("TYPE", "GETS").put("ERROR", error).build();
        return response.copyWith(message: error);
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
      extra: extra,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async* {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = encryptor.type == ApiRequest.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == encryptor.status.ok) &&
                data is Map<String, dynamic>) {
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
              log
                  .put("TYPE", "LIVE")
                  .put("URL", url)
                  .put("ERROR", error)
                  .build();
              controller.addError(
                response.copyWith(snapshot: reference, message: error),
              );
            }
          });
        } else {
          const error = "Unacceptable request!";
          log.put("TYPE", "LIVE").put("ERROR", error).build();
          controller.addError(
            response.copyWith(message: error),
          );
        }
      } else {
        const error = "Undefined request!";
        log.put("TYPE", "LIVE").put("ERROR", error).build();
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("TYPE", "LIVE").put("ERROR", _).build();
      controller.addError(_);
    }
    controller.stream;
  }

  @override
  Stream<Response<List<T>>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async* {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      if (extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentSource(source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = encryptor.type == ApiRequest.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == encryptor.status.ok) &&
                data is List<dynamic>) {
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
        } else {
          const error = "Unacceptable request!";
          log.put("TYPE", "LIVES").put("ERROR", error).build();
          controller.addError(
            response.copyWith(message: error),
          );
        }
      } else {
        const error = "Undefined request!";
        log.put("TYPE", "LIVE").put("ERROR", error).build();
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("TYPE", "LIVES").put("ERROR", _).build();
      controller.addError(_);
    }

    controller.stream;
  }
}

class EncryptedApi extends Api {
  final String key;
  final String iv;
  final String passcode;
  final ApiRequest type;
  final Map<String, dynamic> Function(
    String request,
    String passcode,
  ) request;
  final dynamic Function(Map<String, dynamic> data) response;

  const EncryptedApi({
    required super.api,
    required this.key,
    required this.iv,
    required this.passcode,
    required this.request,
    required this.response,
    this.type = ApiRequest.post,
    super.status = const ApiStatus(),
  });

  crypto.Key get _key => crypto.Key.fromUtf8(key);

  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  crypto.Encrypter get _en {
    return crypto.Encrypter(
      crypto.AES(_key, mode: crypto.AESMode.cbc),
    );
  }

  Future<Map<String, dynamic>> input(dynamic data) => compute(_encoder, data);

  dynamic output(dynamic data) => compute(_decoder, data);

  Future<Map<String, dynamic>> _encoder(dynamic data) async {
    final encrypted = _en.encrypt(jsonEncode(data), iv: _iv);
    return request.call(encrypted.base64, passcode);
  }

  Future<Map<String, dynamic>> _decoder(dynamic source) async {
    final value = await response.call(source);
    final encrypted = crypto.Encrypted.fromBase64(value);
    final data = _en.decrypt(encrypted, iv: _iv);
    return jsonDecode(data);
  }
}
