import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/auth_repository.dart';

class SignUpWithCredentialUseCase {
  final AuthRepository repository;

  SignUpWithCredentialUseCase({
    required this.repository,
  });

  Future<Response<UserCredential>> call({
    required AuthCredential credential,
  }) async {
    return repository.signUpWithCredential(credential: credential);
  }
}
