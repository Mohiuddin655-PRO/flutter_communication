import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class RemoveUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  RemoveUserUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.removeCache(id);
  }
}
