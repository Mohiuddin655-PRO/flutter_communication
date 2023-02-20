import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class DeleteUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  DeleteUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.delete(uid);
  }
}
