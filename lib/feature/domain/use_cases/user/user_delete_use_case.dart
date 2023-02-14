import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class UserDeleteUseCase {
  final DatabaseRepository<UserEntity> repository;

  UserDeleteUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.delete(uid);
  }
}
