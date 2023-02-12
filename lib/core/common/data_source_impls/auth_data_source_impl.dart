import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

import '../../../feature/domain/entities/credential.dart';
import '../data_sources/auth_data_source.dart';
import '../responses/response.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final FacebookAuth facebookAuth;
  final FirebaseAuth firebaseAuth;
  final LocalAuthentication localAuth;

  AuthDataSourceImpl({
    required this.facebookAuth,
    required this.firebaseAuth,
    required this.localAuth,
  });

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<Response> signOut() async {
    const response = Response();
    await firebaseAuth.signOut();
    return response.copyWith(result: true);
  }

  @override
  String? get uid => user?.uid;

  @override
  User? get user => firebaseAuth.currentUser;

  @override
  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    const response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.copyWith(result: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.copyWith(message: e.message);
    }
  }

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) async {
    const response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.signInWithCredential(credential);
      log.put("REGISTER", result);
      return response.copyWith(result: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.copyWith(message: e.message);
    }
  }

  @override
  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    const response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log.put("LOGIN", result);
      return response.copyWith(result: result, message: "Sign in successful!");
    } on FirebaseAuthException catch (e) {
      return response.copyWith(message: e.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithFacebook() async {
    const response = Response<Credential>();
    try {
      final token = await facebookAuth.accessToken;
      LoginResult? result;

      result = token == null
          ? await facebookAuth.login(permissions: ['public_profile', 'email'])
          : null;

      log.put("Facebook Auth Result", result);

      final status = result?.status ?? LoginStatus.failed;

      if (token != null || status == LoginStatus.success) {
        final accessToken = result?.accessToken ?? token;
        if (accessToken != null) {
          final credential = FacebookAuthProvider.credential(accessToken.token);
          final fbData = await facebookAuth.getUserData();
          final data = Credential.fromMap(fbData);
          log.put("Facebook Auth Credential", credential);
          return response.copyWith(
            result: data.copyWith(
              accessToken: accessToken.token,
              credential: credential,
            ),
          );
        } else {
          return response.copyWith(message: 'Token not valid!');
        }
      } else {
        return response.copyWith(message: 'Token not valid!');
      }
    } on FirebaseAuthException catch (e) {
      return response.copyWith(message: e.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithGoogle() async {
    const response = Response<Credential>();
    try {
      GoogleSignInAccount? result;
      final auth = GoogleSignIn(scopes: ['email']);
      final isSignedIn = await auth.isSignedIn();
      if (isSignedIn) {
        result = await auth.signInSilently();
      } else {
        result = await auth.signIn();
      }
      log.put("Google Auth Result", result);
      if (result != null) {
        final authentication = await result.authentication;
        final idToken = authentication.idToken;
        final accessToken = authentication.accessToken;
        if (accessToken != null && idToken != null) {
          final credential = GoogleAuthProvider.credential(
              idToken: idToken, accessToken: accessToken);
          final receivedData = auth.currentUser;
          final data = Credential(
            id: receivedData?.id,
            email: receivedData?.email,
            name: receivedData?.displayName,
            photo: receivedData?.photoUrl,
          );
          log.put("Google Auth Credential", credential);
          return response.copyWith(
            result: data.copyWith(
              accessToken: accessToken,
              idToken: idToken,
              credential: credential,
            ),
          );
        } else {
          return response.copyWith(message: 'Token not valid!');
        }
      } else {
        return response.copyWith(message: 'Sign in failed!');
      }
    } on FirebaseAuthException catch (e) {
      return response.copyWith(message: e.message);
    }
  }

  @override
  Future<Response<bool>> signInWithBiometric() async {
    const response = Response<bool>();
    try {
      if (!await localAuth.isDeviceSupported()) {
        return response.copyWith(message: "Device isn't supported!");
      } else {
        if (await localAuth.canCheckBiometrics) {
          final authenticated = await localAuth.authenticate(
            localizedReason:
                'Scan your fingerprint (or face or whatever) to authenticate',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
          if (authenticated) {
            return response.copyWith(
                message: "Biometric matched!", result: true);
          } else {
            return response.copyWith(message: "Biometric matching failed!");
          }
        } else {
          return response.copyWith(message: "Can not check bio metrics!");
        }
      }
    } catch (e) {
      return response.copyWith(message: e.toString());
    }
  }
}
