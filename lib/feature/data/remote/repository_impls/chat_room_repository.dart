import '../../../../core/common/data_sources/data_source.dart';
import '../../../../core/common/data_sources/local_user_data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/entities/room_entity.dart';
import '../../../domain/repositories/database_repository.dart';

class ChatRoomRepository extends DatabaseRepository<RoomEntity> {
  final KeepUserDataSource local;
  final DataSource remote;

  ChatRoomRepository({
    required this.local,
    required this.remote,
  });

  @override
  Future<Response> create<R>(
    RoomEntity entity, [
    R? Function(R parent)? source,
  ]) {
    return remote.insert(
      id: entity.id,
      data: entity.source,
      source: source,
    );
  }

  @override
  Future<Response> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.delete(
      id,
      source: source,
    );
  }

  @override
  Future<Response> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.get(
      id,
      source: source,
    );
  }

  @override
  Future<Response> getUpdates<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.getUpdates(
      source: source,
    );
  }

  @override
  Future<Response> gets<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.gets(
      source: source,
    );
  }

  @override
  Stream<Response> live<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.live(
      id,
      source: source,
    );
  }

  @override
  Stream<Response> lives<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.lives(
      source: source,
    );
  }

  @override
  Future<Response> update<R>(
    String id,
    Map<String, dynamic> map, [
    R? Function(R parent)? source,
  ]) {
    return remote.update(
      id,
      map,
      source: source,
    );
  }

  @override
  Future<Response> setCache(RoomEntity entity) {
    return local.insert(entity);
  }

  @override
  Future<Response> getCache(String id) {
    return local.get(id);
  }

  @override
  Future<Response> removeCache(String id) {
    return local.remove(id);
  }
}
