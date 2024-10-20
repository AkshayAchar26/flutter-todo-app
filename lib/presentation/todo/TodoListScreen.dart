import 'dart:developer';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:todo_app/presentation/todo/store/todo_store.dart';

import '../../core/widgets/progress_indicator_widget.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/todo/todo.dart';
import '../../utils/locale/app_localization.dart';

class TodoListScreen extends StatefulWidget {
  final VoidCallback? onFloatingActionButtonPressed;

  TodoListScreen({Key? key, this.onFloatingActionButtonPressed}) : super(key: key);
  @override
  _TodoListScreenState createState() => _TodoListScreenState();

  static _TodoListScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_TodoListScreenState>();
  }
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoStore _todoStore = getIt<TodoStore>();
  final TextEditingController _todoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_todoStore.isLoading) {
      _todoStore.getTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _todoStore.isLoading
            ? CustomProgressIndicatorWidget()
            : _buildListView();
      },
    );
  }

  Widget _buildListView() {
    return _todoStore.todos != null
        ? ListView.separated(
      itemCount: _todoStore.todos!.length,
      separatorBuilder: (context, position) {
        return Divider();
      },
      itemBuilder: (context, position) {
        return _buildListItem(position);
      },
    )
        : Center(
      child: Text(
        AppLocalizations.of(context).translate('home_tv_no_todos_found'),
      ),
    );
  }

  Widget _buildListItem(int position) {
    final todo = _todoStore!.todos![position]; // Assuming 'todos' is the list in your TodoList model
    return ListTile(
      dense: true,
      leading: Icon(Icons.check_circle), // You can change the icon
      title: Text(
        todo.todoName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),

    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_todoStore.errorMessage != null) {
          return _showErrorMessage(_todoStore.errorMessage!);
        }

        return SizedBox.shrink();
      },
    );
  }

  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  void onFloatingActionButtonPressed() {
    // Add your logic here for when the FAB is pressed in TodoListScreen
    _showAddTodoDialog(context);
  }

  Future<dynamic> addTodoItem(String todoText) async {
    try {
      final newTodo = await _todoStore.addTodo(todoText);
      return newTodo;
    } catch (e) {
      return e.toString();
    }
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add To-Do'),
          content: TextField(
            controller: _todoController,
            decoration: InputDecoration(hintText: 'Enter to-do text'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _todoController.clear(); // Clear the text field after canceling
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                // Call the addTodoItem function and handle the result
                // final result = await widget.onFloatingActionButtonPressed?.call(_todoController.text);
                var result;
                if (result is Todo) {
                  // Handle successful to-do addition
                  print("Todo added successfully: ${result.todoName}");
                  _todoStore.addTodo(_todoController.text);
                } else {
                  // Handle error
                  print("Error adding todo: $result");
                  // You might want to display an error message to the user here
                }

                Navigator.of(context).pop();
                _todoController.clear(); // Clear the text field after adding
              },
            ),
          ],
        );
      },
    );
  }

}