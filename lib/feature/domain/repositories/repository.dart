import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../../core/common/responses/response.dart';

abstract class Repository<T extends Entity> {
  Future<Response> create(T entity);

  Future<Response> update(String id, Map<String, dynamic> map);

  Future<Response> delete(String id);

  Future<Response> get(String id);

  Future<Response> gets();

  Future<Response> setCache(T entity) async => Response<T>(result: entity);

  Future<Response> getCache(String id) async => Response<T>();

  Future<Response> removeCache(String id) async => Response<T>();
}
