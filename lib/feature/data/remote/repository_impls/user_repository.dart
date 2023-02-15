import 'package:flutter_communication/core/common/data_sources/firebase_data_source.dart';

import '../../../../core/common/data_sources/local_user_data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/database_repository.dart';

class UserRepository extends DatabaseRepository<UserEntity> {
  final KeepUserDataSource localDataSource;
  final FirebaseDataSource remoteDataSource;

  UserRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Response> create(UserEntity entity) {
    return remoteDataSource.insert(entity.uid ?? '', entity.source);
  }

  @override
  Future<Response> update(String id, Map<String, dynamic> map) {
    return remoteDataSource.update(id, map);
  }

  @override
  Future<Response> delete(String id) {
    return remoteDataSource.delete(id);
  }

  @override
  Future<Response> get(String id) {
    return remoteDataSource.get(id);
  }

  @override
  Future<Response> gets() {
    return remoteDataSource.gets();
  }

  @override
  Future<Response> getUpdates() {
    return remoteDataSource.getUpdates();
  }

  @override
  Future<Response> setCache(UserEntity entity) {
    return localDataSource.insert(entity);
  }

  @override
  Future<Response> removeCache(String id) {
    return localDataSource.remove(id);
  }

  @override
  Future<Response> getCache(String id) {
    return localDataSource.get(id);
  }

  @override
  Stream<Response> lives() {
    return remoteDataSource.lives();
  }
}
