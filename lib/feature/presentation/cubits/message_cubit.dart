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
    required String roomId,
    required MessageEntity entity,
  }) async {
    if (Validator.isValidString(entity.id)) {
      final response = await addMessageUseCase.call(
        entity: entity,
        roomId: roomId,
      );
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
    required String roomId,
    required String messageId,
    required Map<String, dynamic> map,
  }) async {
    if (Validator.isValidString(roomId) && Validator.isValidString(messageId)) {
      final response = await updateMessageUseCase.call(
        roomId: roomId,
        id: messageId,
        map: map,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: map));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'Requirement not valid!'));
    }
  }

  Future<void> get({
    required String roomId,
    required String messageId,
  }) async {
    if (Validator.isValidString(roomId) && Validator.isValidString(messageId)) {
      final response = await getMessageUseCase.call(
        id: messageId,
        roomId: roomId,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: response.result));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'Requirement not valid!'));
    }
  }

  Future<void> gets({
    required String roomId,
  }) async {
    final response = await getsMessageUseCase.call(
      roomId: roomId,
    );
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> getUpdates({
    required String roomId,
  }) async {
    final response = await getsUpdateMessageUseCase.call(
      roomId: roomId,
    );
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> delete({
    required String roomId,
    required String messageId,
  }) async {
    if (Validator.isValidString(messageId)) {
      final response = await deleteMessageUseCase.call(
        roomId: roomId,
        id: messageId,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: messageId));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }
}
