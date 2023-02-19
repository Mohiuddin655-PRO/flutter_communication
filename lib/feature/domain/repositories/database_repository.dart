import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../../core/common/responses/response.dart';

abstract class DatabaseRepository<T extends Entity> {
  Future<Response> create<R>(
    T entity, [
    R? Function(R parent)? source,
  ]);

  Future<Response> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]);

  Future<Response> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]);

  Future<Response> gets<R>([
    R? Function(R parent)? source,
  ]);

  Future<Response> getUpdates<R>([
    R? Function(R parent)? source,
  ]);

  Stream<Response> lives<R>([
    R? Function(R parent)? source,
  ]);

  Future<Response> update<R>(
    String id,
    Map<String, dynamic> map, [
    R? Function(R parent)? source,
  ]);

  Future<Response> setCache(T entity) async => Response<T>(result: entity);

  Future<Response> getCache(String id) async => Response<T>();

  Future<Response> removeCache(String id) async => Response<T>();
}
