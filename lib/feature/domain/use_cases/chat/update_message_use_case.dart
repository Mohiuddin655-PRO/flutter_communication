import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/constants/contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../entities/message_entity.dart';
import '../../repositories/database_repository.dart';

class UpdateMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  UpdateMessageUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String id,
    required String roomId,
    required Map<String, dynamic> map,
    R? Function(R parent)? source,
  }) async {
    return repository.update(id, map, (parent) {
      if (parent is CollectionReference) {
        return parent.doc(roomId).collection(ApiPaths.messages);
      }
      if (parent is DatabaseReference) {
        return parent.child(roomId).child(ApiPaths.messages);
      }
    });
  }
}
