import 'package:flutter_communication/core/common/data_sources/fire_store_data_source.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

class UserDataSource extends FireStoreDataSource<UserEntity> {
  UserDataSource({
    super.path = 'users',
  });

  @override
  UserEntity build(source) {
    final data = UserEntity.from(source);
    print("User Data : $data");
    return data;
  }
}
