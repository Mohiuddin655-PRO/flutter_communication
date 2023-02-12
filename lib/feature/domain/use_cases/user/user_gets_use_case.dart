import '../../../../core/common/responses/response.dart';
import '../../repositories/user_repository.dart';

class UserGetsUseCase {
  final UserRepository repository;

  UserGetsUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.gets();
  }
}
