import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    final String? name,
    final String? email,
    final String? uid,
    final String? photo,
    final String? password,
  }) : super(
          name: name,
          email: email,
          password: password,
          photo: photo,
          id: uid,
        );
}
