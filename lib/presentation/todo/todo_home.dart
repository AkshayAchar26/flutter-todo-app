import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/di/service_locator.dart';
import 'package:todo_app/presentation/todo/ad_todo.dart';
import 'package:todo_app/presentation/todo/edit_todo.dart';
import 'package:todo_app/presentation/todo/store/todo_store.dart';

import '../../data/sharedpref/constants/preferences.dart';
import '../../utils/locale/app_localization.dart';
import '../../utils/routes/routes.dart';
import '../home/store/language/language_store.dart';
import '../home/store/theme/theme_store.dart';


class TodoHome extends StatefulWidget {

  TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();
  final TodoStore _todoStore = getIt<TodoStore>();
  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: _buildActions(context),
      ),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              // final todo = todoStore.todos[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are you sure you want to delete?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Task Deleted"),
                              ));
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                background: Container(
                  child: Icon(
                    Icons.delete,
                  ),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(right: 20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color.fromARGB(255, 253, 211, 42),
                    child: ListTile(
                      title: Text("Todo",
                      style: TextStyle(
                        color: Color.fromARGB(255, 42, 42, 42),
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      // EditTodo(todo: todo)
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.edit_outlined,
                          color: Color.fromARGB(255, 42, 42, 42),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _themeStore.darkMode ? Color.fromARGB(255, 253, 211, 42) : Color.fromARGB(255, 42, 42, 42),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      AddTodo()
                    ],
                  ),
                );
              });  // Example
        },
        child: Icon(Icons.add,
          color: _themeStore.darkMode ? Color.fromARGB(255, 42, 42, 42) : Color.fromARGB(255, 253, 211, 42),
        ),
      ),
    );
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.sunny : Icons.brightness_3,
            color: _themeStore.darkMode ? Colors.white : Color.fromARGB(255, 42, 42, 42),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
        color: _themeStore.darkMode ? Colors.white : Color.fromARGB(255, 42, 42, 42),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
        color: _themeStore.darkMode ? Colors.white : Color.fromARGB(255, 42, 42, 42),
      ),
    );
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: AlertDialog(
        // borderRadius: 5.0,
        // enableFullWidth: true,

        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
        ),
        // headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // closeButtonColor: Colors.white,
        // enableCloseButton: true,
        // enableBackButton: false,
        // onCloseButtonClicked: () {
        //   Navigator.of(context).pop();
        // },
        actions: _languageStore.supportedLanguages
        // children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
            dense: true,
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              object.language,
              style: TextStyle(
                color: _languageStore.locale == object.locale
                    ? Theme.of(context).primaryColor
                    : _themeStore.darkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // change user language based on selected locale
              _languageStore.changeLanguage(object.locale);
            },
          ),
        )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
