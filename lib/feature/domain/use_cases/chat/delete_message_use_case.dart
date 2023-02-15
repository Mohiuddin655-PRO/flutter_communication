import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class DeleteMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  DeleteMessageUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
  }) async {
    return repository.delete(id);
  }
}
