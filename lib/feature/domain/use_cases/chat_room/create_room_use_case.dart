import '../../../../core/common/responses/response.dart';
import '../../entities/room_entity.dart';
import '../../repositories/database_repository.dart';

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
