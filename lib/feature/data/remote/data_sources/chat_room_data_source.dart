import 'package:flutter_communication/contents.dart';
import 'package:flutter_communication/core/common/data_sources/fire_store_data_source.dart';
import 'package:flutter_communication/core/common/data_sources/realtime_data_source.dart';
import 'package:flutter_communication/feature/domain/entities/room_entity.dart';

class ChatRoomDataSource extends RealtimeDataSource<RoomEntity> {
  ChatRoomDataSource({
    super.path = ApiPaths.chatRooms,
  });

  @override
  RoomEntity build(source) => RoomEntity.from(source);
}
