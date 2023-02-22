import '../log_builders/log_builder.dart';
import '../responses/response.dart';

abstract class DataSource<T> {
  Future<Response> insert<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  });

  Future<Response> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
  });

  Future<Response<List<T>>> gets<R>({
    R? Function(R parent)? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  });

  Stream<Response<List<T>>> lives<R>({
    R? Function(R parent)? source,
  });

  Future<Response<List<T>>> getUpdates<R>({
    R? Function(R parent)? source,
  });

  Future<Response> delete<R>(
    String id, {
    R? Function(R parent)? source,
  });

  T build(dynamic source);

  LogBuilder get log => LogBuilder("firebase_data_source");
}
