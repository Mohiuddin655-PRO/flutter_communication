import '../../../../core/common/responses/response.dart';
import '../../entities/room_entity.dart';
import '../../repositories/database_repository.dart';

class LiveChatsUseCase {
  final DatabaseRepository<RoomEntity> repository;

  LiveChatsUseCase({
    required this.repository,
  });

  Stream<Response> call() => repository.lives();
}
