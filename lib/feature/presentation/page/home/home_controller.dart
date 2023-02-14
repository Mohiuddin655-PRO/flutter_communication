import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';

class HomeController extends UserCubit {
  HomeController({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.userGetUseCase,
    required super.userGetsUseCase,
  });
}
