import '../../../../core/common/responses/response.dart';
import '../../entities/credential.dart';
import '../../repositories/auth_repository.dart';

class SignInWithFacebookUseCase {
  final AuthRepository repository;

  SignInWithFacebookUseCase({
    required this.repository,
  });

  Future<Response<Credential>> call() async {
    return repository.signInWithFacebook();
  }
}
