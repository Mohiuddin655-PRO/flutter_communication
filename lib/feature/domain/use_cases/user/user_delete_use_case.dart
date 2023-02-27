import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class DeleteUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  DeleteUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.delete(uid);
  }
}
