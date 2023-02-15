import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class LiveMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  LiveMessageUseCase({
    required this.repository,
  });

  Stream<Response> call() {
    return repository.lives();
  }
}
