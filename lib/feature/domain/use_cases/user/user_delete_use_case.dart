import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';

class UserDeleteUseCase {
  final Repository repository;

  UserDeleteUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.delete(uid);
  }
}
