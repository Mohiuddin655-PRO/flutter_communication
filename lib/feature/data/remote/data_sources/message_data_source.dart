import '../../../../core/constants/contents.dart';
import '../../../../core/common/data_sources/fire_store_data_source.dart';
import '../../../domain/entities/message_entity.dart';

class MessageDataSource extends FireStoreDataSource<MessageEntity> {
  MessageDataSource({
    super.path = ApiPaths.chatRooms,
  });

  @override
  MessageEntity build(source) => MessageEntity.from(source);
}
