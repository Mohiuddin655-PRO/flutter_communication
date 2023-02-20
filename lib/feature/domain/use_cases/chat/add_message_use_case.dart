import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/contents.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class AddMessageUseCase {
  final DatabaseRepository<MessageEntity> repository;

  AddMessageUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String roomId,
    required MessageEntity entity,
  }) async {
    return repository.create(entity, (parent) {
      if (parent is CollectionReference) {
        return parent.doc(roomId).collection(ApiPaths.messages);
      }
      if (parent is DatabaseReference) {
        return parent.child(roomId).child(ApiPaths.messages);
      }
    });
  }
}
