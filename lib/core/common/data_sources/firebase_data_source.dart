import '../log_builders/log_builder.dart';
import '../responses/response.dart';

abstract class FirebaseDataSource {
  Future<Response> insert(String id, Map<String, dynamic> data);

  Future<Response> update(String id, Map<String, dynamic> data);

  Future<Response> get(String id);

  Future<Response> gets();

  Future<Response> delete(String id);

  LogBuilder get log => LogBuilder("firebase_data_source");
}
