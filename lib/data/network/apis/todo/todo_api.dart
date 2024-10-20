import 'package:dio/dio.dart';

import '../../../../core/data/network/dio/dio_client.dart';
import '../../../sharedpref/shared_preference_helper.dart';
import '../../constants/endpoints.dart';

class TodoApi {
  final DioClient _dioClient;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  TodoApi(this._dioClient, this._sharedPreferenceHelper);

  Future<void> createTodo(String todoName) async {
    try {
      final token = await _sharedPreferenceHelper.authToken;
      final response = await _dioClient.dio.get(Endpoints.createTodo,
          options: Options(headers: {"authorization": "Bearer $token"}),
          data: {"todoName": todoName});

      if (response.statusCode == 201) {
        print('Todo created successfully');
      } else {
        print('Error creating todo: ${response.statusCode}');
        throw Exception('Failed to create todo');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> updateTodo(int todoId, String newTodoName,String isCompleted) async {
    try {
      final token = await _sharedPreferenceHelper.authToken;
      final response = await _dioClient.dio.put(
        '${Endpoints.updateTodo}/$todoId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {"todoName": newTodoName,"isCompleted":isCompleted},
      );

      if (response.statusCode == 200) {
        print('Todo updated successfully');
      } else {
        print('Error updating todo: ${response.statusCode}');
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> deleteTodo(int todoId) async {
    try {
      final token = await _sharedPreferenceHelper.authToken;
      final response = await _dioClient.dio.delete(
        '${Endpoints.deleteTodo}/$todoId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 204) {
        print('Todo deleted successfully');
      } else {
        print('Error deleting todo: ${response.statusCode}');
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Future<List<Todo>> getTodos() async {
  //   try {
  //     final token = await _sharedPreferenceHelper.authToken;
  //     final response = await _dioClient.dio.get(
  //       Endpoints.getTodos,
  //       options: Options(headers: {"Authorization": "Bearer $token"}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = response.data;
  //       return jsonData.map((json) => Todo.fromJson(json)).toList();
  //     } else {
  //       print('Error getting todos: ${response.statusCode}');
  //       throw Exception('Failed to get todos');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }
}
