class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";
  // static const String baseUrl = "http://localhost:4000";


  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // TodoRoute
  static const String todoRoute = baseUrl + "/todo";
  static const String createTodo = todoRoute + "/addTodo";
  static const String updateTodo = todoRoute + "/updateTodo";
  static const String getTodos = todoRoute + "getTodo";
  static const String deleteTodo = todoRoute + "deleteTodo";

  //ProfileRoute
  static const String profileRoute = baseUrl + "/profile";




}