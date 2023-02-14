import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/repository.dart';
import '../../repositories/user_repository.dart';

class UserCreateUseCase {
  final Repository repository;

  UserCreateUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.create(entity);
  }
}
