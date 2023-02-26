import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/responses/response.dart';
import '../../../feature/domain/entities/base_entity.dart';
import 'data_source.dart';

abstract class FireStoreDataSource<T extends Entity> extends DataSource<T> {
  final String path;

  FireStoreDataSource({required this.path});

  FirebaseFirestore? _db;

  FirebaseFirestore get database => _db ??= FirebaseFirestore.instance;

  CollectionReference _source<R>(
    R? Function(R parent)? source,
  ) {
    final parent = database.collection(path);
    dynamic current = source?.call(parent as R);
    if (current is CollectionReference) {
      return current;
    } else {
      return parent;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if ((id ?? "").isNotEmpty) {
      //final reference = database.collection(path).doc(id);
      final reference = _source(source).doc(id ?? "");
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
      return response.copyWith(message: "Id isn't valid!");
    }
  }

  @override
  Future<Response> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      //await database.collection(path).doc(id).update(data);
      await _source(source).doc(id).update(data);
      return response.copyWith(result: true);
    } catch (_) {
      log.put("UPDATE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      //await database.collection(path).doc(id).delete();
      await _source(source).doc(id).delete();
      return response.copyWith(result: true);
    } catch (_) {
      log.put("DELETE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      //final result = await database.collection(path).doc(id).get();
      final result = await _source(source).doc(id).get();
      log.put("GET", result);
      if (result.exists && result.data() != null) {
        return response.copyWith(result: build(result.data()));
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } catch (_) {
      log.put("GET", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<List<T>>();
    try {
      //final result = await database.collection(path).get();
      final result = await _source(source).get();
      log.put("GETS", result);
      if (result.docs.isNotEmpty || result.docChanges.isNotEmpty) {
        if (onlyUpdatedData) {
          List<T> list = result.docChanges.map((e) {
            return build(e.doc.data());
          }).toList();
          return response.copyWith(result: list);
        } else {
          List<T> list = result.docs.map((e) {
            return build(e.data());
          }).toList();
          return response.copyWith(result: list);
        }
      } else {
        return response.copyWith(message: "Data not found!");
      }
    } catch (_) {
      log.put("GETS", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    return gets(
      onlyUpdatedData: true,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).doc(id).snapshots().listen((event) {
        log.put("GET", event);
        if (event.exists || event.data() != null) {
          controller.add(response.copyWith(result: build(event.data())));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      log.put("GET", _.toString());
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<List<T>>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      _source(source).snapshots().listen((event) {
        log.put("GETS", event);
        if (event.docs.isNotEmpty || event.docChanges.isNotEmpty) {
          if (onlyUpdatedData) {
            List<T> list = event.docChanges.map((e) {
              return build(e.doc.data());
            }).toList();
            controller.add(response.copyWith(result: list));
          } else {
            List<T> list = event.docs.map((e) {
              return build(e.data());
            }).toList();
            controller.add(response.copyWith(result: list));
          }
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      log.put("GETS", _.toString());
      controller.addError(_);
    }

    return controller.stream;
  }
}
