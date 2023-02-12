import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class UserSaveUseCase {
  final UserRepository repository;

  UserSaveUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.save(entity);
  }
}
