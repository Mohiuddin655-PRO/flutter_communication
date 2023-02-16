import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class LiveMessagesUseCase {
  final DatabaseRepository<MessageEntity> repository;

  LiveMessagesUseCase({
    required this.repository,
  });

  Stream<Response> call() {
    return repository.lives();
  }
}
