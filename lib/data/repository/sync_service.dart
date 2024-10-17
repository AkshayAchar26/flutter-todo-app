import 'package:todo_app/data/local/datasources/todo/todo_datasource.dart';
import 'package:todo_app/network/network.dart';

class SyncService {
  // 1. Data Source and Storage:
  // Define how data is accessed and stored locally.

  final TodoDatasource _todoDatasource;
  final NetworkInfo _networkInfo;

  SyncService(this._todoDatasource,this._networkInfo);

  Future<void> synchronize() async {
    if (await _networkInfo.hasInternet()) {
      await _uploadLocalChanges();
      await _downloadRemoteChanges();
    }
  }

  Future<void> _uploadLocalChanges() async {
    // 1. Get pending local changes (e.g., from a queue or by status)
    final pendingTodos = await _todoDatasource.getPendingTodos(); // Assume this method exists
    // 2. Upload each pending change to the remote data source
    for (final todo in pendingTodos) {
      try {
        // await _remoteDataSource.updateTodo(todo); // Or insert/delete based on status
        // Update local status to synchronized
        await _todoDatasource.markTodoAsSynced(todo.id!); // Assume this method exists
      } catch (e) {
        print('Error uploading todo: $e');
        // Handle error (e.g., retry, store error information)
      }
    }
  }


 Future<void> _downloadRemoteChanges() async {
  try {
    // 1. Fetch all todos from the remote data source
    // final remoteTodos = await _remoteDataSource.getTodos();
    final remoteTodos = [];

    // 2. Update local data with remote changes
    for (final remoteTodo in remoteTodos) {
      final existingTodo = await _todoDatasource.getTodoById(remoteTodo.id!); // Assuming this method exists

      if (existingTodo == null) {
        // Insert new remote todo into local storage
        await _todoDatasource.addTodo(remoteTodo);
      } else {
        // Update existing local todo with remote data (conflict resolution)
        // Example: Last-write-wins strategy (use remote if newer)
        if (remoteTodo.updatedAt!.isAfter(existingTodo.updatedAt!)) {
          await _todoDatasource.updateTodo(remoteTodo);
          
        } else {
          // Optionally, handle other conflict resolution strategies
          // ...
        }
      }
    }
  } catch (e) {
    print('Error downloading todos: $e');
    // Handle error, e.g., retry, display error message
  }
}


}
