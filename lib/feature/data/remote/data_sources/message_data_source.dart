import 'package:flutter_communication/core/common/data_sources/fire_store_data_source.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

class MessageDataSource extends FireStoreDataSource<MessageEntity> {
  MessageDataSource({
    super.path = 'messages',
  });

  @override
  MessageEntity build(source) {
    final data = MessageEntity.from(source);
    print("Message Data : $data");
    return data;
  }
}
