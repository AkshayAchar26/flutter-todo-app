import 'package:sembast/sembast.dart';
import 'package:todo_app/core/data/local/sembast/sembast_client.dart';
import 'package:todo_app/data/local/constants/db_constants.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';

class TodoDatasource {
  final SembastClient _sembastClient;
  final StoreRef<String, Map<String, dynamic>> _todoStore;

  TodoDatasource(this._sembastClient)
      : _todoStore = stringMapStoreFactory.store(DBConstants.STORE_TODO_NAME);

  Future<List<Todo>> getTodoList() async {
    final finder = Finder();
    try {
      final records =
          await _todoStore.find(_sembastClient.database, finder: finder);
      return records.map((snapshot) => _mapRecordToTodo(snapshot)).toList();
    } catch (e) {
      // Handle or log the error more specifically
      print('Error getting todo list: $e');
      rethrow; // Re-throw after handling
    }
  }

  Future<void> addTodo(Todo todo) async {
    // Ensure todo.id is not null
    if (todo.id == null) {
      // Handle missing ID, e.g., generate a new one
      throw ArgumentError('Todo ID cannot be null');
    }
    try {
      await _todoStore
          .record(todo.id!)
          .put(_sembastClient.database, todo.toMap());
    } catch (e) {
      // Handle or log the error more specifically
      print('Error adding todo: $e');
      rethrow;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    // Ensure todo.id is not null
    if (todo.id == null) {
      throw ArgumentError('Todo ID cannot be null');
    }
    try {
      final finder = Finder(filter: Filter.byKey(todo.id!));
      await _todoStore.update(_sembastClient.database, todo.toMap(),
          finder: finder);
    } catch (e) {
      // Handle or log the error more specifically
      print('Error updating todo: $e');
      rethrow;
    }
  }

  Future<void> deleteAsset(String todoId) async {
    try {
      await _todoStore.record(todoId).delete(_sembastClient.database);
    } catch (e) {
      // Handle or log the error more specifically
      print('Error deleting todo: $e');
      rethrow;
    }
  }

  Todo _mapRecordToTodo(RecordSnapshot<String, Map<String, dynamic>> snapshot) {
    final todoMap = Todo.fromMap(snapshot.value);
    return Todo(
      id: snapshot.key,
      todoName: todoMap.todoName,
      createdAt: todoMap.createdAt,
      updatedAt: todoMap.updatedAt,
      isCompleted: todoMap.isCompleted,
    );
  }

  Future<void> updateTodoList(List<Todo> todos) async {
    await _sembastClient.database.transaction((txn) async {
      for (final todo in todos) {
        final finder = Finder(filter: Filter.byKey(todo.id!));
        await _todoStore.update(txn, todo.toMap(), finder: finder);
      }
    });
  }

  Future<List<Todo>> getPendingTodos() async {
    final finder =
        Finder(filter: Filter.equals('syncStatus', SyncStatus.pending.name));
    try {
      final records =
          await _todoStore.find(_sembastClient.database, finder: finder);
      return records.map((snapshot) => _mapRecordToTodo(snapshot)).toList();
    } catch (e) {
      print('Error getting pending todos: $e');
      rethrow;
    }
  }

  Future<void> markTodoAsSynced(String todoId) async {
    try {
      final finder = Finder(filter: Filter.byKey(todoId));
      await _todoStore.update(
        _sembastClient.database,
        {'syncStatus': SyncStatus.syncronized.name},
        finder: finder,
      );
    } catch (e) {
      print('Error marking todo as synced: $e');
      rethrow;
    }
  }

  Future<Todo?> getTodoById(String todoId) async {
    final finder = Finder(filter: Filter.byKey(todoId));
    try {
      final record =
          await _todoStore.find(_sembastClient.database, finder: finder);
        return record.isNotEmpty ? _mapRecordToTodo(record.first) : null;
    } catch (e) {
      print('Error getting todo by ID: $e');
      rethrow;
    }
  }
}
