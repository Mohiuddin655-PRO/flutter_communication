import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/data_source_impls/auth_data_source_impl.dart';
import 'core/common/data_source_impls/keep_user_data_source_impl.dart';
import 'core/common/data_sources/auth_data_source.dart';
import 'core/common/data_sources/firebase_data_source.dart';
import 'core/common/data_sources/keep_user_data_source.dart';
import 'feature/data/remote/data_sources/user_data_source.dart';
import 'feature/data/remote/repository_impls/auth_repository_impl.dart';
import 'feature/data/remote/repository_impls/user_repository_impl.dart';
import 'feature/domain/repositories/auth_repository.dart';
import 'feature/domain/repositories/user_repository.dart';
import 'feature/domain/use_cases/auth/is_sign_in_use_case.dart';
import 'feature/domain/use_cases/auth/sign_in_with_biometric_use_case.dart';
import 'feature/domain/use_cases/auth/sign_in_with_email_n_password_use_case.dart';
import 'feature/domain/use_cases/auth/sign_in_with_facebook_use_case.dart';
import 'feature/domain/use_cases/auth/sign_in_with_google_use_case.dart';
import 'feature/domain/use_cases/auth/sign_out_use_case.dart';
import 'feature/domain/use_cases/auth/sign_up_with_credential_use_case.dart';
import 'feature/domain/use_cases/auth/sign_up_with_email_n_password_use_case.dart';
import 'feature/domain/use_cases/user/user_backup_use_case.dart';
import 'feature/domain/use_cases/user/user_create_use_case.dart';
import 'feature/domain/use_cases/user/user_delete_use_case.dart';
import 'feature/domain/use_cases/user/user_remove_use_case.dart';
import 'feature/domain/use_cases/user/user_save_use_case.dart';
import 'feature/domain/use_cases/user/user_update_use_case.dart';
import 'feature/presentation/cubits/auth_cubit.dart';
import 'feature/presentation/cubits/user_cubit.dart';

GetIt locator = GetIt.instance;

Future<void> init() async {
  // Cubit
  locator.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: locator(),
        signUpWithCredentialUseCase: locator(),
        signUpWithEmailAndPasswordUseCase: locator(),
        signInWithEmailAndPasswordUseCase: locator(),
        signInWithFacebookUseCase: locator(),
        signInWithGoogleUseCase: locator(),
        signInWithBiometricUseCase: locator(),
        signOutUseCase: locator(),
        userCreateUseCase: locator(),
        userSaveUseCase: locator(),
        userBackupUseCase: locator(),
        userRemoveUseCase: locator(),
      ));
  locator.registerFactory<UserCubit>(() => UserCubit(
        createUseCase: locator(),
        updateUseCase: locator(),
        deleteUseCase: locator(),
      ));

  //Auth use cases
  locator.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: locator()));
  locator.registerLazySingleton<SignUpWithCredentialUseCase>(
      () => SignUpWithCredentialUseCase(repository: locator()));
  locator.registerLazySingleton<SignUpWithEmailAndPasswordUseCase>(
      () => SignUpWithEmailAndPasswordUseCase(repository: locator()));
  locator.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
      () => SignInWithEmailAndPasswordUseCase(repository: locator()));
  locator.registerLazySingleton<SignInWithFacebookUseCase>(
      () => SignInWithFacebookUseCase(repository: locator()));
  locator.registerLazySingleton<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(repository: locator()));
  locator.registerLazySingleton<SignInWithBiometricUseCase>(
      () => SignInWithBiometricUseCase(repository: locator()));
  locator.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: locator()));

  //User use cases
  locator.registerLazySingleton<UserCreateUseCase>(
      () => UserCreateUseCase(repository: locator()));
  locator.registerLazySingleton<UserUpdateUseCase>(
      () => UserUpdateUseCase(repository: locator()));
  locator.registerLazySingleton<UserDeleteUseCase>(
      () => UserDeleteUseCase(repository: locator()));
  locator.registerLazySingleton<UserSaveUseCase>(
      () => UserSaveUseCase(repository: locator()));
  locator.registerLazySingleton<UserBackupUseCase>(
      () => UserBackupUseCase(repository: locator()));
  locator.registerLazySingleton<UserRemoveUseCase>(
      () => UserRemoveUseCase(repository: locator()));

  // Repository
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(source: locator.call()));
  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remote: locator.call(), local: locator()));

  //Data Source
  locator.registerLazySingleton<LocalDataSource>(
      () => KeepUserDataSourceImpl(preferences: locator()));
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(
        facebookAuth: locator(),
        firebaseAuth: locator(),
        localAuth: locator(),
      ));
  locator.registerLazySingleton<FirebaseDataSource>(() => UserDataSource());

  //External
  final local = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final facebookAuth = FacebookAuth.instance;
  final biometricAuth = LocalAuthentication();
  final database = FirebaseFirestore.instance;
  final realtime = FirebaseDatabase.instance;
  locator.registerLazySingleton<SharedPreferences>(() => local);
  locator.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  locator.registerLazySingleton<FacebookAuth>(() => facebookAuth);
  locator.registerLazySingleton<LocalAuthentication>(() => biometricAuth);
  locator.registerLazySingleton<FirebaseFirestore>(() => database);
  locator.registerLazySingleton<FirebaseDatabase>(() => realtime);
  await locator.allReady();
}
