import 'package:flutter_communication/core/common/data_source_impls/realtime_data_source_impl.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

class UserDataSource extends RealtimeDataSourceImpl<UserEntity> {
  UserDataSource({
    super.path = 'users',
  });

  @override
  UserEntity build(source) {
    final data = UserEntity.from(source);
    print("Raw data : $data");
    return data;
  }
}
