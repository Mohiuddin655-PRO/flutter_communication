import '../log_builders/log_builder.dart';
import '../responses/response.dart';

abstract class DataSource<T> {
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  });

  Future<Response> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response<List<T>>> gets<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Stream<Response<List<T>>> lives<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response<List<T>>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  T build(dynamic source);

  LogBuilder get log => LogBuilder("Source");
}
