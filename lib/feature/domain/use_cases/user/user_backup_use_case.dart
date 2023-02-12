import '../../../../core/common/responses/response.dart';
import '../../repositories/user_repository.dart';

class UserBackupUseCase {
  final UserRepository repository;

  UserBackupUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.backup();
  }
}
