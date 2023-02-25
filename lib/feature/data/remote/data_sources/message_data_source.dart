import 'package:flutter_communication/contents.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/data_sources/fire_store_data_source.dart';

class MessageDataSource extends FireStoreDataSource<MessageEntity> {
  MessageDataSource({
    super.path = ApiPaths.chatRooms,
  });

  @override
  MessageEntity build(source) => MessageEntity.from(source);
}
