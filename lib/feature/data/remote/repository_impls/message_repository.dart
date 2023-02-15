import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../core/common/data_sources/firebase_data_source.dart';
import '../../../../core/common/data_sources/local_user_data_source.dart';
import '../../../../core/common/responses/response.dart';

class MessageRepository extends DatabaseRepository<MessageEntity> {
  final KeepUserDataSource local;
  final FirebaseDataSource remote;

  MessageRepository({
    required this.local,
    required this.remote,
  });

  @override
  Future<Response> create(MessageEntity entity) {
    return remote.insert(entity.uid ?? '', entity.source);
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
  Future<Response> getUpdates() {
    return remote.getUpdates();
  }

  @override
  Stream<Response> lives() {
    return remote.lives();
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
