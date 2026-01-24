import 'package:expense_lab/domain/repositories/i_repository.dart';
import 'package:isar/isar.dart';

abstract class IsarRepository<E, M> implements IRepository<E> {
  final Isar isar;
  final IsarCollection<M> collection;

  IsarRepository(this.isar, this.collection);

  E mapToEntity(M model);
  M mapToModel(E entity);
  int getModelId(M model);

  @override
  Future<List<E>> getAll() async {
    final List<M> models = await collection.where().findAll();
    return models.map((M m) => mapToEntity(m)).toList();
  }

  @override
  Future<E?> getById(int id) async {
    final M? model = await collection.get(id);
    return model != null ? mapToEntity(model) : null;
  }

  @override
  Future<int> upsert(E entity) async {
    return await isar.writeTxn(() async {
      final M model = mapToModel(entity);
      return await collection.put(model);
    });
  }

  @override
  Future<bool> delete(int id) async {
    return await isar.writeTxn(() => collection.delete(id));
  }
}
