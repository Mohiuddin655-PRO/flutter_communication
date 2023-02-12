import '../../../../core/common/responses/response.dart';
import '../../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.signOut();
  }
}
