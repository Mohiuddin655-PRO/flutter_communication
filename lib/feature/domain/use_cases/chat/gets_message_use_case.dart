import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class GetsMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  GetsMessageUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.gets();
  }
}
