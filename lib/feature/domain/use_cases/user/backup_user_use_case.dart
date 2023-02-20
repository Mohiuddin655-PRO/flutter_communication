import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class BackupUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  BackupUserUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.getCache(id);
  }
}
