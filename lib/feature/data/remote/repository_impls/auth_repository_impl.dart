import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/data_sources/auth_data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/entities/credential.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource source;

  AuthRepositoryImpl({
    required this.source,
  });

  @override
  Future<bool> isSignIn() => source.isSignIn();

  @override
  Future<Response> signOut() => source.signOut();

  @override
  String? get uid => source.uid;

  @override
  User? get user => source.user;

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) {
    return source.signUpWithCredential(credential: credential);
  }

  @override
  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  }) {
    return source.signUpWithEmailNPassword(email: email, password: password);
  }

  @override
  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  }) {
    return source.signInWithEmailNPassword(email: email, password: password);
  }

  @override
  Future<Response<Credential>> signInWithFacebook() {
    return source.signInWithFacebook();
  }

  @override
  Future<Response<Credential>> signInWithGoogle() {
    return source.signInWithGoogle();
  }

  @override
  Future<Response<bool>> signInWithBiometric() {
    return source.signInWithBiometric();
  }
}
