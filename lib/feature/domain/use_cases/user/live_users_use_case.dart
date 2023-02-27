import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class LiveUsersUseCase {
  final DatabaseRepository<UserEntity> repository;

  LiveUsersUseCase({
    required this.repository,
  });

  Stream<Response> call() {
    return repository.lives();
  }
}
