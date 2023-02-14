import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';

class UserGetsUseCase {
  final Repository repository;

  UserGetsUseCase({
    required this.repository,
  });

  Future<Response> call() async {
    return repository.gets();
  }
}
