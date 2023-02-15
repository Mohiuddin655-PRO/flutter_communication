import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../../../core/common/responses/response.dart';
import 'firebase_data_source.dart';

abstract class RealtimeDataSource<T extends Entity>
    extends FirebaseDataSource<T> {
  final String path;

  RealtimeDataSource({required this.path});

  FirebaseDatabase? _db;

  FirebaseDatabase get database => _db ??= FirebaseDatabase.instance;

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response> insert(String id, Map<String, dynamic> data) async {
    const response = Response();
    if (id.isNotEmpty) {
      final reference = database.ref(path).child(id);
      return await reference.get().then((value) async {
        if (!value.exists) {
          await reference.set(data);
          return response.copyWith(result: data);
        } else {
          log.put("INSERT", value);
          return response.copyWith(
              snapshot: value, message: 'Already inserted!');
        }
      });
    } else {
      return response.copyWith(message: "ID isn't valid!");
    }
  }

  @override
  Future<Response> update(String id, Map<String, dynamic> data) async {
    const response = Response();
    try {
      await database.ref(path).child(id).update(data);
      return response.copyWith(result: true);
    } catch (_) {
      log.put("UPDATE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete(String id) async {
    const response = Response();
    try {
      await database.ref(path).child(id).remove();
      return response.copyWith(result: true);
    } catch (_) {
      log.put("DELETE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get(String id) async {
    final response = Response<T>();
    try {
      final result = await database.ref(path).child(id).get();
      log.put("GET", result);
      if (result.exists) {
        return response.copyWith(result: build(result.value));
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } catch (_) {
      log.put("GET", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets({
    bool onlyUpdatedData = false,
  }) async {
    final response = Response<List<T>>();
    try {
      final result = await database.ref(path).get();
      log.put("GETS", result);
      if (result.exists) {
        List<T> list = result.children.map((e) {
          return build(e.value);
        }).toList();
        return response.copyWith(result: list);
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } on Exception catch (_) {
      log.put("GETS", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates() => gets(onlyUpdatedData: true);
}
