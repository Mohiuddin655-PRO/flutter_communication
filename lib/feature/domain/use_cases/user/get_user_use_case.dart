import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class GetUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  GetUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.get(uid);
  }
}
