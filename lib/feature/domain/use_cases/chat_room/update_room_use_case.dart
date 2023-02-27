import '../../../../core/common/responses/response.dart';
import '../../entities/room_entity.dart';
import '../../repositories/database_repository.dart';

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
