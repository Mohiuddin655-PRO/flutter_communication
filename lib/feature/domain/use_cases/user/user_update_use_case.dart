import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';

class UserUpdateUseCase {
  final Repository repository;

  UserUpdateUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    return repository.update(uid, map);
  }
}
