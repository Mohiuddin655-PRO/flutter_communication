import '../../../../core/common/data_sources/firebase_data_source.dart';
import '../../../../core/common/data_sources/keep_user_data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final LocalDataSource local;
  final FirebaseDataSource remote;

  UserRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Response> create(UserEntity entity) {
    return remote.insert(entity.uid ?? '', entity.map);
  }

  @override
  Future<Response> update(String uid, Map<String, dynamic> map) {
    return remote.update(uid, map);
  }

  @override
  Future<Response> delete(String uid) {
    return remote.delete(uid);
  }

  @override
  Future<Response> get(String uid) {
    return remote.get(uid);
  }

  @override
  Future<Response> gets() {
    return remote.gets();
  }

  @override
  Future<Response> save(UserEntity entity) {
    return local.insert(entity);
  }

  @override
  Future<Response> remove() {
    return local.remove();
  }

  @override
  Future<Response> backup() {
    return local.get();
  }
}
