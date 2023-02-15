import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class GetsUpdateMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  GetsUpdateMessageUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.getUpdates();
  }
}
