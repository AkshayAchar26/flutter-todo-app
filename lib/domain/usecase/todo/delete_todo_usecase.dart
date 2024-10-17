import 'package:todo_app/core/domain/usecase/use_case.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';
import 'package:todo_app/domain/repository/todo/todo_repository.dart';

class DeleteTodoUsecase extends UseCase<void, Todo> {
  final TodoRepository _todoRepository;

  DeleteTodoUsecase(this._todoRepository);

  @override
  Future<void> call({required params}) {
    return _todoRepository.delete(params);
  }
}