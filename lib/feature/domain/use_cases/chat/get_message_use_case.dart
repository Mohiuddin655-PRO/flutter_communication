import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/constants/contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../entities/message_entity.dart';
import '../../repositories/database_repository.dart';

class GetMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  GetMessageUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String roomId,
    required String id,
    R? Function(R parent)? source,
  }) async {
    return repository.get(id, (parent) {
      if (parent is CollectionReference) {
        return parent.doc(roomId).collection(ApiPaths.messages);
      }
      if (parent is DatabaseReference) {
        return parent.child(roomId).child(ApiPaths.messages);
      }
    });
  }
}
