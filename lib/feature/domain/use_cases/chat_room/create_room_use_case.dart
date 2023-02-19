import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../core/common/responses/response.dart';

class CreateRoomUseCase {
  final DatabaseRepository<RoomEntity> repository;

  CreateRoomUseCase({
    required this.repository,
  });

  Future<Response> call({
    required RoomEntity entity,
  }) async {
    return repository.create(entity);
  }
}
