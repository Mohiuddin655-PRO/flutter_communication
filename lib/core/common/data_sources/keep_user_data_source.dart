import '../log_builders/log_builder.dart';
import '../responses/response.dart';

abstract class LocalDataSource<T> {
  LogBuilder get log => LogBuilder("local_data_source");

  Future<Response> insert(T entity);

  Future<Response> remove();

  Future<Response> get();
}
