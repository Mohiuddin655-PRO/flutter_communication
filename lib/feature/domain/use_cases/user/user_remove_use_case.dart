import '../../../../core/common/responses/response.dart';
import '../../repositories/user_repository.dart';

class UserRemoveUseCase {
  final UserRepository repository;

  UserRemoveUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.remove();
  }
}
