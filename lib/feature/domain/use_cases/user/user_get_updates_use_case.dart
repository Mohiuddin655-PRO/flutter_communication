import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class UserGetUpdatesUseCase {
  final DatabaseRepository<UserEntity> repository;

  UserGetUpdatesUseCase({
    required this.repository,
  });

  Future<Response> call() async => repository.getUpdates();
}
