import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class RemoveUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  RemoveUserUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.removeCache(id);
  }
}
