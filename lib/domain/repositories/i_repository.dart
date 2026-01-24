abstract class IRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<int> upsert(T entity);
  Future<bool> delete(int id);
}
