import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
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
