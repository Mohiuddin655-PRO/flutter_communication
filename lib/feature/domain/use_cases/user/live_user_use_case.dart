import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class LiveUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  LiveUserUseCase({
    required this.repository,
  });

  Stream<Response> call({required String uid}) => repository.live(uid);
}
