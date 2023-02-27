import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class UpdateUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  UpdateUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    return repository.update(uid, map);
  }
}
