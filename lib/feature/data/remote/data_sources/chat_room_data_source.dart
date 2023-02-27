import '../../../../core/constants/contents.dart';
import '../../../../core/common/data_sources/fire_store_data_source.dart';
import '../../../domain/entities/room_entity.dart';

class ChatRoomDataSource extends FireStoreDataSource<RoomEntity> {
  ChatRoomDataSource({
    super.path = ApiPaths.chatRooms,
  });

  @override
  RoomEntity build(source) => RoomEntity.from(source);
}
