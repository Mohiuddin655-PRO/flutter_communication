import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/user/user_create_use_case.dart';
import '../../domain/use_cases/user/user_delete_use_case.dart';
import '../../domain/use_cases/user/user_update_use_case.dart';

class UserCubit extends Cubit<CubitState> {
  final UserCreateUseCase createUseCase;
  final UserUpdateUseCase updateUseCase;
  final UserDeleteUseCase deleteUseCase;

  UserCubit({
    required this.createUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(CubitState(
          isFirstLoading: false,
          isLoading: false,
          exception: '',
        ));

  Future<void> create({
    required UserEntity entity,
  }) async {
    if (Validator.isValidString(entity.uid)) {
      final response = await createUseCase.call(entity: entity);
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
      final response = await updateUseCase.call(uid: uid, map: map);
      if (response.isSuccessful) {
        emit(state.copyWith(data: map));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> delete({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await deleteUseCase.call(uid: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: uid));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }
}
