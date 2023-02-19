import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/repositories/database_repository.dart';

import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';

class LiveMessagesUseCase {
  final DatabaseRepository<MessageEntity> repository;

  LiveMessagesUseCase({
    required this.repository,
  });

  Stream<Response> call<R>({
    required String roomId,
  }) {
    return repository.lives((parent) {
      if (parent is CollectionReference) {
        return parent.doc(roomId).collection(ApiPaths.messages);
      }
      if (parent is DatabaseReference) {
        return parent.child(roomId).child(ApiPaths.messages);
      }
    });
  }
}
