import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../core/common/responses/response.dart';

class UpdateRoomUseCase {
  final DatabaseRepository<RoomEntity> repository;

  UpdateRoomUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return repository.update(id, data);
  }
}
