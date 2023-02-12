import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/auth_repository.dart';

class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignUpWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Response<UserCredential>> call({
    required String email,
    required String password,
  }) async {
    return repository.signUpWithEmailNPassword(
      email: email,
      password: password,
    );
  }
}
