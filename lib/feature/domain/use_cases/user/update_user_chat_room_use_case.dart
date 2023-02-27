import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';
import '../../repositories/database_repository.dart';

class UpdateUserChatRoomUseCase {
  final DatabaseRepository<UserEntity> repository;

  UpdateUserChatRoomUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
    required List<String> rooms,
  }) async {
    return repository.update(uid, {
      "chat_rooms": rooms,
    });
  }
}
