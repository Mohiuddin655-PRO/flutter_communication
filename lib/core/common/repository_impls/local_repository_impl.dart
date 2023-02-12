import '../data_sources/local_data_source.dart';
import '../repositories/local_repository.dart';
import '../responses/response.dart';

class LocalRepositoryImpl extends LocalRepository {
  final LocalDataSource source;

  LocalRepositoryImpl({required this.source});

  @override
  bool isAvailable(String key, List<dynamic>? list) =>
      source.isAvailable(key, list);

  @override
  Future<bool?> alreadyAdded({
    required String collectionKey,
    required String documentKey,
  }) {
    return source.availabilityCheck(
      path: collectionKey,
      key: documentKey,
    );
  }

  @override
  Future<Response<List<dynamic>>> insert({
    required String path,
    required String key,
    required dynamic data,
  }) {
    return source.insert(
      path: path,
      key: key,
      data: data,
    );
  }

  @override
  Future<Response<List<dynamic>>> remove({
    required String path,
    required String key,
    required dynamic data,
  }) {
    return source.remove(
      path: path,
      key: key,
      data: data,
    );
  }

  @override
  Future<Response<List<dynamic>>> getCollection({
    required String collectionKey,
  }) {
    return source.getCollection(path: collectionKey);
  }

  @override
  Future<Response<List<dynamic>>> setCollection({
    required String collectionKey,
    required List<dynamic> collection,
  }) {
    return source.setCollection(
      path: collectionKey,
      data: collection,
    );
  }

  @override
  Future<Response<void>> clear({
    required String collectionKey,
  }) {
    return source.clear(path: collectionKey);
  }
}
