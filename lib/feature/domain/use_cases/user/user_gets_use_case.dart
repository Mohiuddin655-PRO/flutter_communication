import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class UserGetsUseCase {
  final DatabaseRepository<UserEntity> repository;

  UserGetsUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.gets();
  }
}
