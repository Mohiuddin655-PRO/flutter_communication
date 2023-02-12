import '../../../../core/common/responses/response.dart';
import '../../repositories/user_repository.dart';

class UserDeleteUseCase {
  final UserRepository repository;

  UserDeleteUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.delete(uid);
  }
}
