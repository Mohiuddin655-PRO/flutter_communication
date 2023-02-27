import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class CreateUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  CreateUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.create(entity);
  }
}
