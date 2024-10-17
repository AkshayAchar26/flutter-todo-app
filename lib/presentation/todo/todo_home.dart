import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:todo_app/di/service_locator.dart';
import 'package:todo_app/presentation/todo/store/todo_store.dart';


class TodoHome extends StatelessWidget {
  final TodoStore todoStore = getIt<TodoStore>();

  TodoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: todoStore.todos.length,
            itemBuilder: (context, index) {
              final todo = todoStore.todos[index];
              return ListTile(
                title: Text(todo.todoName!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to add new todo
          todoStore.addTodo('New Todo'); // Example
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
