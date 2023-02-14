import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/repository.dart';

class AddMessageUseCase {
  final Repository repository;

  AddMessageUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.create(entity);
  }
}
