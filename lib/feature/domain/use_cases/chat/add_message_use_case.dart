import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class AddMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  AddMessageUseCase({
    required this.repository,
  });

  Future<Response> call({
    required MessageEntity entity,
  }) async {
    return repository.create(entity);
  }
}
