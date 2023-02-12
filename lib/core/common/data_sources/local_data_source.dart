import '../responses/response.dart';

abstract class LocalDataSource {
  bool isAvailable(String key, List<dynamic>? list);

  Future<bool?> availabilityCheck({
    required String path,
    required String key,
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
    required String path,
  });

  Future<Response<List<dynamic>>> setCollection({
    required String path,
    required List<dynamic> data,
  });

  Future<Response<void>> clear({
    required String path,
  });
}
