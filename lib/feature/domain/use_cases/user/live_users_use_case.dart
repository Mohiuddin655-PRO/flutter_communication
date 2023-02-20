import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class LiveUsersUseCase {
  final DatabaseRepository<UserEntity> repository;

  LiveUsersUseCase({
    required this.repository,
  });

  Stream<Response> call() {
    return repository.lives();
  }
}
