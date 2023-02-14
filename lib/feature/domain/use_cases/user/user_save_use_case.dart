import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class UserSaveUseCase {
  final DatabaseRepository<UserEntity> repository;

  UserSaveUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.setCache(entity);
  }
}
