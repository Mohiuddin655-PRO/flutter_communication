import 'package:flutter_communication/feature/domain/entities/room_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class LiveChatsUseCase {
  final DatabaseRepository<RoomEntity> repository;

  LiveChatsUseCase({
    required this.repository,
  });

  Stream<Response> call() => repository.lives();
}
