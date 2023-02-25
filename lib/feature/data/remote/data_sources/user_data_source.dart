import 'package:flutter_communication/contents.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import '../../../../core/common/data_sources/fire_store_data_source.dart';

class UserDataSource extends FireStoreDataSource<UserEntity> {
  UserDataSource({
    super.path = ApiPaths.users,
  });

  @override
  UserEntity build(source) => UserEntity.from(source);
}
