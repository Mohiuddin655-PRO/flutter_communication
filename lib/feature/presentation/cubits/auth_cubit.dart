import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/responses/response.dart';
import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/auth/is_sign_in_use_case.dart';
import '../../domain/use_cases/auth/sign_in_with_biometric_use_case.dart';
import '../../domain/use_cases/auth/sign_in_with_email_n_password_use_case.dart';
import '../../domain/use_cases/auth/sign_in_with_facebook_use_case.dart';
import '../../domain/use_cases/auth/sign_in_with_google_use_case.dart';
import '../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../domain/use_cases/auth/sign_up_with_credential_use_case.dart';
import '../../domain/use_cases/auth/sign_up_with_email_n_password_use_case.dart';
import '../../domain/use_cases/user/backup_user_use_case.dart';
import '../../domain/use_cases/user/create_user_use_case.dart';
import '../../domain/use_cases/user/user_remove_use_case.dart';
import '../../domain/use_cases/user/user_save_use_case.dart';

class AuthCubit extends Cubit<CubitState> {
  final IsSignInUseCase isSignInUseCase;
  final SignUpWithCredentialUseCase signUpWithCredentialUseCase;
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithBiometricUseCase signInWithBiometricUseCase;
  final SignOutUseCase signOutUseCase;
  final CreateUserUseCase userCreateUseCase;
  final SaveUserUseCase userSaveUseCase;
  final BackupUserUseCase userBackupUseCase;
  final RemoveUserUseCase userRemoveUseCase;

  AuthCubit({
    required this.isSignInUseCase,
    required this.signUpWithCredentialUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signInWithFacebookUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithBiometricUseCase,
    required this.signOutUseCase,
    required this.userCreateUseCase,
    required this.userSaveUseCase,
    required this.userBackupUseCase,
    required this.userRemoveUseCase,
  }) : super(CubitState());

  static String get uid => user?.uid ?? "uid";

  static User? get user => FirebaseAuth.instance.currentUser;

  Future<bool> get isLoggedIn async {
    try {
      emit(state.copyWith(isLoading: true));
      final signedIn = await isSignInUseCase.call();
      if (signedIn) {
        emit(state.copyWith(data: true));
      } else {
        emit(state.copyWith(exception: "User logged out!"));
      }
      return signedIn;
    } catch (e) {
      emit(state.copyWith(exception: e.toString()));
      return Future.error(e);
    }
  }

  Future<Response> signUpByEmail(UserEntity entity) async {
    const cubitResponse = Response();
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(state.copyWith(exception: "Email isn't valid!"));
      return cubitResponse.copyWith(message: "Email isn't valid!");
    } else if (!Validator.isValidPassword(password)) {
      emit(state.copyWith(exception: "Password isn't valid!"));
      return cubitResponse.copyWith(message: "Password isn't valid!");
    } else {
      try {
        emit(state.copyWith(isLoading: true));
        final response = await signUpWithEmailAndPasswordUseCase.call(
          email: email,
          password: password,
        );
        final result = response.result?.user;
        if (result != null) {
          final user = entity.copyWith(
            id: result.uid,
            email: result.email,
            phone: result.phoneNumber,
            name: result.displayName,
            photo: result.photoURL,
          );
          final userResponse = await userCreateUseCase.call(entity: user);
          if (userResponse.isSuccessful || userResponse.snapshot != null) {
            await userSaveUseCase.call(entity: user);
            emit(state.copyWith(data: user));
          } else {
            emit(state.copyWith(exception: userResponse.message));
          }
          return userResponse.copyWith(result: user);
        } else {
          emit(state.copyWith(exception: response.message));
          return response;
        }
      } catch (e) {
        emit(state.copyWith(exception: e.toString()));
        return cubitResponse.copyWith(message: e.toString());
      }
    }
  }

  Future<Response> signInByEmail(UserEntity entity) async {
    const cubitResponse = Response();
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(state.copyWith(exception: "Email isn't valid!"));
      return cubitResponse.copyWith(message: "Email isn't valid!");
    } else if (!Validator.isValidPassword(password)) {
      emit(state.copyWith(exception: "Password isn't valid!"));
      return cubitResponse.copyWith(message: "Password isn't valid!");
    } else {
      try {
        emit(state.copyWith(isLoading: true));
        final response = await signInWithEmailAndPasswordUseCase.call(
          email: email,
          password: password,
        );
        final result = response.result?.user;
        if (result != null) {
          final user = entity.copyWith(
            id: result.uid,
            email: result.email,
            name: result.displayName,
            phone: result.phoneNumber,
            photo: result.photoURL,
            provider: AuthProvider.email.name,
          );
          final userResponse = await userCreateUseCase.call(entity: user);
          if (userResponse.isSuccessful || userResponse.snapshot != null) {
            await userSaveUseCase.call(entity: user);
            emit(state.copyWith(data: user));
          } else {
            emit(state.copyWith(exception: userResponse.message));
          }
          return userResponse.copyWith(result: user);
        } else {
          emit(state.copyWith(exception: response.message));
          return response;
        }
      } catch (e) {
        emit(state.copyWith(exception: e.toString()));
        return cubitResponse.copyWith(message: e.toString());
      }
    }
  }

  Future<Response> signInByFacebook(UserEntity entity) async {
    emit(state.copyWith(isLoading: true));
    final response = await signInWithFacebookUseCase.call();
    final result = response.result;
    if (result != null && result.credential != null) {
      final finalResponse = await signUpWithCredentialUseCase.call(
        credential: result.credential!,
      );
      if (finalResponse.isSuccessful) {
        final currentData = finalResponse.result?.user;
        final user = entity.copyWith(
          id: currentData?.uid ?? result.id,
          email: result.email,
          name: result.name,
          photo: result.photo,
          provider: AuthProvider.facebook.name,
        );
        final userResponse = await userCreateUseCase.call(entity: user);
        if (userResponse.isSuccessful || userResponse.snapshot != null) {
          await userSaveUseCase.call(entity: user);
          emit(state.copyWith(data: user));
        } else {
          emit(state.copyWith(exception: userResponse.message));
        }
        return userResponse.copyWith(result: user);
      } else {
        emit(state.copyWith(exception: finalResponse.message));
        return finalResponse;
      }
    } else {
      emit(state.copyWith(exception: response.message));
      return response;
    }
  }

  Future<Response> signInByGoogle(UserEntity entity) async {
    emit(state.copyWith(isLoading: true));
    final response = await signInWithGoogleUseCase.call();
    final result = response.result;
    if (result != null && result.credential != null) {
      final finalResponse = await signUpWithCredentialUseCase.call(
        credential: result.credential!,
      );
      if (finalResponse.isSuccessful) {
        final currentData = finalResponse.result?.user;
        final user = entity.copyWith(
          id: currentData?.uid ?? result.id,
          name: result.name,
          photo: result.photo,
          email: result.email,
          provider: AuthProvider.google.name,
        );
        final userResponse = await userCreateUseCase.call(entity: user);
        if (userResponse.isSuccessful || userResponse.snapshot != null) {
          await userSaveUseCase.call(entity: user);
          emit(state.copyWith(data: user));
        } else {
          emit(state.copyWith(exception: userResponse.message));
        }
        return userResponse.copyWith(result: user);
      } else {
        emit(state.copyWith(exception: finalResponse.message));
        return finalResponse;
      }
    } else {
      emit(state.copyWith(exception: response.message));
      return response;
    }
  }

  Future<Response> signInByBiometric() async {
    emit(state.copyWith(isLoading: true));
    final response = await signInWithBiometricUseCase.call();
    if (response.isSuccessful) {
      final userResponse = await userBackupUseCase.call(uid);
      final user = userResponse.result;
      if (userResponse.isSuccessful && user is UserEntity) {
        final email = user.email;
        final password = user.password;
        final loginResponse = await signInWithEmailAndPasswordUseCase.call(
          email: email,
          password: password,
        );
        if (loginResponse.isSuccessful) {
          emit(state.copyWith(data: loginResponse.result));
        } else {
          emit(state.copyWith(exception: loginResponse.message));
        }
        return loginResponse;
      } else {
        emit(state.copyWith(exception: userResponse.message));
      }
      return userResponse;
    } else {
      emit(state.copyWith(exception: response.message));
    }
    return response;
  }

  Future<Response> signOut() async {
    emit(state.copyWith(isLoading: true));
    final response = await signOutUseCase.call();
    if (response.isSuccessful) {
      final userResponse = await userRemoveUseCase.call(uid);
      if (userResponse.isSuccessful || userResponse.snapshot != null) {
        emit(state.copyWith(data: null));
      } else {
        emit(state.copyWith(exception: userResponse.message));
      }
      return userResponse.copyWith(result: response.result);
    } else {
      emit(state.copyWith(exception: response.message));
      return response;
    }
  }

  Future<Response> backup(UserEntity entity) async =>
      await userBackupUseCase.call(uid);

  Future<Response> saveData(UserEntity entity) async =>
      await userSaveUseCase.call(entity: entity);

  Future<Response> remove(UserEntity entity) async =>
      await userRemoveUseCase.call(uid);
}
