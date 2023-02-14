import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';

class UserBackupUseCase {
  final Repository repository;

  UserBackupUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.getCache(id);
  }
}
