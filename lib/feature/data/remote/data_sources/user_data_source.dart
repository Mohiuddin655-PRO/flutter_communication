import '../../../../core/common/data_source_impls/realtime_data_source_impl.dart';

class UserDataSource extends RealtimeDataSourceImpl {
  UserDataSource({
    super.path = 'users',
  });
}
