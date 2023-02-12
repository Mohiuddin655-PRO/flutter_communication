import '../responses/response.dart';

abstract class LocalRepository {
  bool isAvailable(String key, List<dynamic>? list);

  Future<bool?> alreadyAdded({
    required String collectionKey,
    required String documentKey,
  });

  Future<Response<List<dynamic>>> insert({
    required String path,
    required String key,
    required dynamic data,
  });

  Future<Response<List<dynamic>>> remove({
    required String path,
    required String key,
    required dynamic data,
  });

  Future<Response<List<dynamic>>> getCollection({
    required String collectionKey,
  });

  Future<Response<List<dynamic>>> setCollection({
    required String collectionKey,
    required List<dynamic> collection,
  });

  Future<Response<void>> clear({
    required String collectionKey,
  });
}
