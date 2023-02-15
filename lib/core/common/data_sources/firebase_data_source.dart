import '../log_builders/log_builder.dart';
import '../responses/response.dart';

abstract class FirebaseDataSource<T> {
  Future<Response> insert(String id, Map<String, dynamic> data);

  Future<Response> update(String id, Map<String, dynamic> data);

  Future<Response<T>> get(String id);

  Future<Response<List<T>>> gets();

  Stream<Response<List<T>>> lives();

  Future<Response<List<T>>> getUpdates();

  Future<Response> delete(String id);

  T build(dynamic source);

  LogBuilder get log => LogBuilder("firebase_data_source");
}
