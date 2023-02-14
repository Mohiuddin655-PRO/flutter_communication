import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';
import '../../repositories/user_repository.dart';

class UserRemoveUseCase {
  final Repository repository;

  UserRemoveUseCase({
    required this.repository,
  });

  Future<Response> call(String id) async {
    return repository.removeCache(id);
  }
}
