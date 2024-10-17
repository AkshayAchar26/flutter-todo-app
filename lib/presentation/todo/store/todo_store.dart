import 'package:mobx/mobx.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';
import 'package:todo_app/domain/usecase/todo/delete_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/get_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/insert_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/update_todo_usecae.dart';
import 'package:uuid/uuid.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  final GetTodoUsecase _getTodoUsecase;
  final InsertTodoUsecase _insertTodoUsecase;
  final UpdateTodoUsecae _updateTodoUsecase;
  final DeleteTodoUsecase _deleteTodoUsecase;

  _TodoStore(
    this._getTodoUsecase,
    this._insertTodoUsecase,
    this._updateTodoUsecase,
    this._deleteTodoUsecase,
  ) {
    _init();
  }

  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> _init() async {
    isLoading = true;
    try {
      todos = ObservableList.of(await _getTodoUsecase.call(params: null));
    } catch (e) {
      errorMessage = 'Failed to load todos';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addTodo(String todo) async {
    var uuid = Uuid();
    isLoading = true;
    Todo newTodo = Todo(
        id: uuid.v4(),
        todoName: todo,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCompleted: false,
        syncStatus: SyncStatus.pending);
    try {
      await _insertTodoUsecase.call(params: newTodo);
      todos.add(newTodo);
    } catch (e) {
      errorMessage = 'Failed to add todo';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateTodo(Todo todo) async {
    isLoading = true;
    try {
      await _updateTodoUsecase.call(params: todo);
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo;
      }
    } catch (e) {
      errorMessage = 'Failed to update todo';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteTodo(Todo todo) async {
    isLoading = true;
    try {
      await _deleteTodoUsecase.call(params: todo);
      todos.removeWhere((t) => t.id == todo.id);
    } catch (e) {
      errorMessage = 'Failed to delete todo';
    } finally {
      isLoading = false;
    }
  }
}
