import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/user_remove_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/user_save_use_case.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/user/user_backup_use_case.dart';
import '../../domain/use_cases/user/user_create_use_case.dart';
import '../../domain/use_cases/user/user_delete_use_case.dart';
import '../../domain/use_cases/user/user_get_use_case.dart';
import '../../domain/use_cases/user/user_gets_use_case.dart';
import '../../domain/use_cases/user/user_update_use_case.dart';

class UserCubit extends Cubit<CubitState> {
  final UserBackupUseCase userBackupUseCase;
  final UserCreateUseCase userCreateUseCase;
  final UserDeleteUseCase userDeleteUseCase;
  final UserGetUseCase userGetUseCase;
  final UserGetsUseCase userGetUpdatesUseCase;
  final UserGetsUseCase userGetsUseCase;
  final UserRemoveUseCase userRemoveUseCase;
  final UserSaveUseCase userSaveUseCase;
  final UserUpdateUseCase userUpdateUseCase;

  UserCubit({
    required this.userBackupUseCase,
    required this.userCreateUseCase,
    required this.userDeleteUseCase,
    required this.userGetUseCase,
    required this.userGetUpdatesUseCase,
    required this.userGetsUseCase,
    required this.userRemoveUseCase,
    required this.userSaveUseCase,
    required this.userUpdateUseCase,
  }) : super(CubitState());

  Future<void> create({
    required UserEntity entity,
  }) async {
    if (Validator.isValidString(entity.uid)) {
      final response = await userCreateUseCase.call(entity: entity);
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> update({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await userUpdateUseCase.call(uid: uid, map: map);
      if (response.isSuccessful) {
        emit(state.copyWith(data: map));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> get({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await userGetUseCase.call(uid: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: response.result));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> gets() async {
    final response = await userGetsUseCase.call();
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> getUpdates() async {
    final response = await userGetUpdatesUseCase.call();
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> delete({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await userDeleteUseCase.call(uid: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: uid));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> save({
    required UserEntity entity,
  }) async {
    if (Validator.isValidString(entity.uid)) {
      final response = await userUpdateUseCase.call(
        uid: "uid",
        map: entity.source,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> remove() async {
    final response = await userRemoveUseCase.call("uid");
    if (response.isSuccessful) {
      emit(state.copyWith(data: null));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> backup() async {
    final response = await userBackupUseCase.call("uid");
    if (response.isSuccessful) {
      emit(state.copyWith(data: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }
}
