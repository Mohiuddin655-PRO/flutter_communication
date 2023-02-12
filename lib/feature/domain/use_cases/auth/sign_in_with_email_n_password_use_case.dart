import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Response<UserCredential>> call({
    required String email,
    required String password,
  }) async {
    return repository.signInWithEmailNPassword(
      email: email,
      password: password,
    );
  }
}
