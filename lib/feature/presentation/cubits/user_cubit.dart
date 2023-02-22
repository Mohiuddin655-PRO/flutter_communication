import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat_room/create_room_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/update_user_chat_room_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/user_remove_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/user_save_use_case.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/base_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/user/backup_user_use_case.dart';
import '../../domain/use_cases/user/create_user_use_case.dart';
import '../../domain/use_cases/user/get_user_use_case.dart';
import '../../domain/use_cases/user/user_delete_use_case.dart';
import '../../domain/use_cases/user/user_gets_use_case.dart';
import '../../domain/use_cases/user/user_update_use_case.dart';

class UserCubit extends Cubit<CubitState> {
  final BackupUserUseCase userBackupUseCase;
  final CreateUserUseCase userCreateUseCase;
  final DeleteUserUseCase userDeleteUseCase;
  final GetUserUseCase userGetUseCase;
  final GetUsersUseCase userGetUpdatesUseCase;
  final GetUsersUseCase userGetsUseCase;
  final RemoveUserUseCase userRemoveUseCase;
  final SaveUserUseCase userSaveUseCase;
  final UpdateUserUseCase userUpdateUseCase;
  final UpdateUserChatRoomUseCase updateUserRoomUseCase;
  final CreateRoomUseCase createRoomUseCase;

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
    required this.updateUserRoomUseCase,
    required this.createRoomUseCase,
  }) : super(CubitState());

  Future<void> create({
    required UserEntity entity,
  }) async {
    if (Validator.isValidString(entity.id)) {
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

  Future<bool> createRoom({
    required String roomId,
    required UserEntity me,
    required UserEntity friend,
  }) async {
    const response = Response();
    if (Validator.isValidString(roomId) &&
        Validator.isValidString(me.id) &&
        Validator.isValidString(friend.id)) {
      final userRooms = me.chatRooms.map((e) => e).toList();
      userRooms.insert(0, roomId);

      final friendRooms = friend.chatRooms.map((e) => e).toList();
      friendRooms.insert(0, roomId);

      final room = RoomEntity(
        id: roomId,
        timeMS: Entity.timeMills,
        type: ChattingType.none,
        owner: me.id,
        contributor: friend.id,
      );

      await createRoomUseCase.call(entity: room);
      await updateUserRoomUseCase.call(uid: me.id, rooms: userRooms);
      await updateUserRoomUseCase.call(uid: friend.id, rooms: friendRooms);
      return true;
    } else {
      return false;
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

  Future<void> updateState({
    required UserEntity entity,
  }) async {
    emit(state.copyWith(data: entity));
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
    if (Validator.isValidString(entity.id)) {
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
