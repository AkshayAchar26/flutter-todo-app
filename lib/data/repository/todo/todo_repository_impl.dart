import 'package:todo_app/data/local/datasources/todo/todo_datasource.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';
import 'package:todo_app/domain/repository/todo/todo_repository.dart';
import 'package:todo_app/network/network.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDatasource _localDataSource; // Renamed for clarity
  final NetworkInfo _networkInfo;
  // Assume you have a remote data source:
  // final RemoteDataSource _remoteDataSource; 

  TodoRepositoryImpl(this._localDataSource, this._networkInfo); 

  @override
  Future<void> delete(Todo todo) async {
    try {
      await _localDataSource.deleteAsset(todo.id!);
      if (await _networkInfo.hasInternet()) {
        // Delete from remote if online
        // await _remoteDataSource.deleteTodo(todo.id!);
      } else {
        // Mark for synchronization
        // ... (e.g., add to a pending changes queue)
      }
    } catch (e) {
      // Handle errors
      print('Error deleting todo: $e');
      rethrow; 
    }
  }

  @override
  Future<List<Todo>> getPosts() async {
    try {
      if (await _networkInfo.hasInternet()) {
        // Fetch from remote and update local
        // final remoteTodos = await _remoteDataSource.getTodos();
        // await _localDataSource.updateTodoList(remoteTodos); // Update local cache
        // return remoteTodos; 
        return _localDataSource.getTodoList();
      } else {
        // Return from local
        return _localDataSource.getTodoList();
      }
    } catch (e) {
      // Handle errors
      print('Error getting todos: $e');
      rethrow;
    }
  }

  @override
  Future<void> insert(Todo todo) async {
    try {
      await _localDataSource.addTodo(todo);
      if (await _networkInfo.hasInternet()) {
        // Insert into remote if online
        // await _remoteDataSource.insertTodo(todo);
      } else {
        // Mark for synchronization
        // ...
      }
    } catch (e) {
      // Handle errors
      print('Error inserting todo: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(Todo localTodo) async {
    try {
      await _localDataSource.updateTodo(localTodo);
      if (await _networkInfo.hasInternet()) {
        // Update on remote and handle conflicts
        // final remoteTodo = await _remoteDataSource.getTodo(localTodo.id!);
        // if (localTodo.updatedAt.isAfter(remoteTodo.updatedAt)) {
        //   await _remoteDataSource.updateTodo(localTodo);
        // } else {
        //   // Handle conflict (e.g., last-write-wins, manual merge)
        //   // ...
        // }
      } else {
        // Mark for synchronization
        // ...
      }
    } catch (e) {
      // Handle errors
      print('Error updating todo: $e');
      rethrow;
    }
  }
}
