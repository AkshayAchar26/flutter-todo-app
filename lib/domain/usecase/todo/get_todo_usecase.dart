import 'package:todo_app/core/domain/usecase/use_case.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';
import 'package:todo_app/domain/repository/todo/todo_repository.dart';

class GetTodoUsecase extends UseCase<List<Todo>, void> {

  final TodoRepository _todoRepository;

  GetTodoUsecase(this._todoRepository);

  @override
  Future<List<Todo>> call({required params}) {
    return _todoRepository.getPosts();
  }
}