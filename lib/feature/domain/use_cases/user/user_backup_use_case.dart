import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class UserBackupUseCase {
  final DatabaseRepository<UserEntity> repository;

  UserBackupUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.getCache(id);
  }
}
