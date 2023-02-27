import '../../../../core/common/responses/response.dart';
import '../../entities/room_entity.dart';
import '../../repositories/database_repository.dart';

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
