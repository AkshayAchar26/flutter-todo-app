import '../../entity/todo/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getPosts();

  Future<void> insert(Todo todo);

  Future<void> update(Todo todo);

  Future<void> delete(Todo todo);
}