import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/delete_message_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/update_message_use_case.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/use_cases/chat/add_message_use_case.dart';
import '../../domain/use_cases/chat/get_message_use_case.dart';
import '../../domain/use_cases/chat/gets_message_use_case.dart';
import '../../domain/use_cases/chat/gets_update_message_use_case.dart';

class MessageCubit extends Cubit<CubitState> {
  final AddMessageUseCase addMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final GetMessageUseCase getMessageUseCase;
  final GetsMessageUseCase getsMessageUseCase;
  final GetsUpdateMessageUseCase getsUpdateMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;

  MessageCubit({
    required this.addMessageUseCase,
    required this.deleteMessageUseCase,
    required this.getMessageUseCase,
    required this.getsMessageUseCase,
    required this.getsUpdateMessageUseCase,
    required this.updateMessageUseCase,
  }) : super(CubitState());

  Future<void> create({
    required MessageEntity entity,
  }) async {
    if (Validator.isValidString(entity.id)) {
      final response = await addMessageUseCase.call(entity: entity);
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'ID is not valid!'));
    }
  }

  Future<void> update({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await updateMessageUseCase.call(id: uid, map: map);
      if (response.isSuccessful) {
        emit(state.copyWith(data: map));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'ID is not valid!'));
    }
  }

  Future<void> get({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await getMessageUseCase.call(id: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: response.result));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'ID is not valid!'));
    }
  }

  Future<void> gets() async {
    final response = await getsMessageUseCase.call();
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> getUpdates() async {
    final response = await getsUpdateMessageUseCase.call();
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
      final response = await deleteMessageUseCase.call(id: uid);
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
