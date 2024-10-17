// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TodoStore on _TodoStore, Store {
  late final _$todosAtom = Atom(name: '_TodoStore.todos', context: context);

  @override
  ObservableList<Todo> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_TodoStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_TodoStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$_initAsyncAction =
      AsyncAction('_TodoStore._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$addTodoAsyncAction =
      AsyncAction('_TodoStore.addTodo', context: context);

  @override
  Future<void> addTodo(String todo) {
    return _$addTodoAsyncAction.run(() => super.addTodo(todo));
  }

  late final _$updateTodoAsyncAction =
      AsyncAction('_TodoStore.updateTodo', context: context);

  @override
  Future<void> updateTodo(Todo todo) {
    return _$updateTodoAsyncAction.run(() => super.updateTodo(todo));
  }

  late final _$deleteTodoAsyncAction =
      AsyncAction('_TodoStore.deleteTodo', context: context);

  @override
  Future<void> deleteTodo(Todo todo) {
    return _$deleteTodoAsyncAction.run(() => super.deleteTodo(todo));
  }

  @override
  String toString() {
    return '''
todos: ${todos},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
