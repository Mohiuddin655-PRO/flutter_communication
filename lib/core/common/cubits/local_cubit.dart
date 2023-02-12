import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/states/cubit_state.dart';
import '../use_cases/local_use_case.dart';

class LocalCubit extends Cubit<CubitState> {
  final String cartsKey = 'carts';
  final LocalUseCase localUseCase;

  LocalCubit({
    required this.localUseCase,
  }) : super(CubitState(
          isFirstLoading: false,
          isLoading: false,
          exception: '',
        ));

  bool isAvailable(String key, List<dynamic>? list) {
    return localUseCase.isAvailable(key, list);
  }

  Future<bool?> isCart(dynamic course) async {
    return localUseCase.alreadyAdded(
      collectionKey: cartsKey,
      documentKey: course.courseId ?? '',
    );
  }

  Future<void> setItem(dynamic document) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await localUseCase.insert(
        path: cartsKey,
        key: document.courseId!,
        data: document,
      );
      emit(state.copyWith(result: response.result, isLoading: false));
    } catch (_) {
      emit(state.copyWith(exception: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> removeItem(dynamic document) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await localUseCase.remove(
        path: cartsKey,
        key: document.courseId ?? '',
        data: document,
      );
      emit(state.copyWith(result: response.result, isLoading: false));
    } catch (_) {
      emit(state.copyWith(exception: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> getItems() async {
    try {
      emit(state.copyWith(isLoading: true));
      final response =
          await localUseCase.getCollection(collectionKey: cartsKey);
      emit(state.copyWith(result: response.result, isLoading: false));
    } catch (_) {
      emit(state.copyWith(exception: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> setItems(List<dynamic> items) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await localUseCase.setCollection(
        collectionKey: cartsKey,
        collection: items,
      );
      emit(state.copyWith(result: response.result, isLoading: false));
    } catch (_) {
      emit(state.copyWith(exception: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      emit(state.copyWith(isLoading: true));
      await localUseCase.clear(collectionKey: cartsKey);
      emit(state.copyWith(result: [], isLoading: false));
    } catch (_) {
      emit(state.copyWith(exception: "Something went wrong!"));
      rethrow;
    }
  }

  dynamic cubitData;

  void setData(dynamic data) {
    cubitData = data;
  }
}
