import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class UpdateUserUseCase {
  final DatabaseRepository<UserEntity> repository;

  UpdateUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    return repository.update(uid, map);
  }
}
