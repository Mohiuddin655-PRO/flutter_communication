import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class GetUsersUseCase {
  final DatabaseRepository<UserEntity> repository;

  GetUsersUseCase({
    required this.repository,
  });

  Future<Response> call() async => repository.gets();
}
