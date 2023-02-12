import '../../../../core/common/responses/response.dart';
import '../../repositories/auth_repository.dart';

class SignInWithBiometricUseCase {
  final AuthRepository repository;

  SignInWithBiometricUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.signInWithBiometric();
  }
}
