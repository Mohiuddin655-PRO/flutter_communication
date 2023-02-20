import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../core/common/responses/response.dart';
import '../../entities/user_entity.dart';

class CreateUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  CreateUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required UserEntity entity,
  }) async {
    return repository.create(entity);
  }
}
