import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../core/common/responses/response.dart';

class DeleteRoomUseCase {
  final DatabaseRepository<RoomEntity> repository;

  DeleteRoomUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
  }) async {
    return repository.delete(id);
  }
}
