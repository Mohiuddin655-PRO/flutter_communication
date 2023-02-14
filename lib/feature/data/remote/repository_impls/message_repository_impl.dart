import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/repository.dart';

import '../../../../core/common/data_sources/firebase_data_source.dart';
import '../../../../core/common/data_sources/keep_user_data_source.dart';
import '../../../../core/common/responses/response.dart';

class MessageRepositoryImpl extends Repository<MessageEntity> {
  final LocalDataSource local;
  final FirebaseDataSource remote;

  MessageRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Response> create(MessageEntity entity) {
    return remote.insert(entity.uid ?? '', entity.map);
  }

  @override
  Future<Response> delete(String id) {
    return remote.delete(id);
  }

  @override
  Future<Response> get(String id) {
    return remote.get(id);
  }

  @override
  Future<Response> gets() {
    return remote.gets();
  }

  @override
  Future<Response> update(String id, Map<String, dynamic> map) {
    return remote.update(id, map);
  }

  @override
  Future<Response> setCache(MessageEntity entity) {
    return local.insert(entity);
  }

  @override
  Future<Response> getCache(String id) {
    return local.get(id);
  }

  @override
  Future<Response> removeCache(String id) {
    return local.remove(id);
  }
}
