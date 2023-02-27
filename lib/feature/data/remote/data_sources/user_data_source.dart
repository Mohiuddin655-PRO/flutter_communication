import '../../../../core/constants/contents.dart';
import '../../../../core/common/data_sources/fire_store_data_source.dart';
import '../../../domain/entities/user_entity.dart';

class UserDataSource extends FireStoreDataSource<UserEntity> {
  UserDataSource({
    super.path = ApiPaths.users,
  });

  @override
  UserEntity build(source) => UserEntity.from(source);
}
