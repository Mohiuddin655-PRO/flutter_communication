import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class UpdateMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  UpdateMessageUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
    required Map<String, dynamic> map,
  }) async {
    return repository.update(id, map);
  }
}
