import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/domain/entity/todo/todo.dart';
import 'package:todo_app/presentation/todo/store/todo_store.dart';

import '../../constants/app_theme.dart';
import '../../di/service_locator.dart';
import '../home/store/theme/theme_store.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key, required this.todo});

  final Todo todo;

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  String _todoName = '';

  final _formKey = GlobalKey<FormState>();
  final TodoStore _store = getIt<TodoStore>();
  final ThemeStore _themeStore = getIt<ThemeStore>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todoName = widget.todo.todoName!;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeStore.darkMode
          ? AppThemeData.darkThemeData
          : AppThemeData.lightThemeData,
      child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          key: UniqueKey(),
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRRect(
              key: UniqueKey(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28, top: 30),
                          child: Text(
                            'Todo Name',
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              initialValue: _todoName,
                              cursorColor:
                              Theme.of(context).colorScheme.inverseSurface,
                              onChanged: (value) {
                                _todoName = value;
                              },
                              style: GoogleFonts.workSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ), // Change border color
                                ),
                                hintText: 'Type here...',
                                border:
                                InputBorder.none, // Remove default border
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 230),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _store.updateTodo(Todo(
                                  todoName: _todoName
                                ));
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _themeStore.darkMode ? Color.fromARGB(255, 253, 211, 42) : Color.fromARGB(255, 42, 42, 42),
                              minimumSize: Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Update Todo',
                              style: GoogleFonts.workSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _themeStore.darkMode ? Color.fromARGB(255, 42, 42, 42) : Color.fromARGB(255, 253, 211, 42),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
