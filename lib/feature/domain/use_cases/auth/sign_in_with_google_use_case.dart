import '../../../../core/common/responses/response.dart';
import '../../entities/credential.dart';
import '../../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase({
    required this.repository,
  });

  Future<Response<Credential>> call() async {
    return repository.signInWithGoogle();
  }
}
