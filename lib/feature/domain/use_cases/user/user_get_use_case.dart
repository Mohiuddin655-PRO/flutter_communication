import '../../../../core/common/responses/response.dart';
import '../../repositories/user_repository.dart';

class UserGetUseCase {
  final UserRepository repository;

  UserGetUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.get(uid);
  }
}
