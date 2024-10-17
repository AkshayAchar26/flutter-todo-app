import 'dart:async';

import 'package:todo_app/domain/repository/todo/todo_repository.dart';
import 'package:todo_app/domain/usecase/todo/delete_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/get_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/insert_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/update_todo_usecae.dart';

import '../../../di/service_locator.dart';
import '../../repository/user/user_repository.dart';
import '../../usecase/user/get_auth_token_usecase.dart';
import '../../usecase/user/get_userId_usecase.dart';
import '../../usecase/user/is_logged_in_usecase.dart';
import '../../usecase/user/login_usecase.dart';
import '../../usecase/user/remove_auth_token_usecase.dart';
import '../../usecase/user/save_auth_token_usecase.dart';
import '../../usecase/user/save_login_in_status_usecase.dart';
import '../../usecase/user/save_userId_usecase.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // user:--------------------------------------------------------------------
    getIt.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<SaveLoginStatusUseCase>(
      SaveLoginStatusUseCase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<GetAuthTokenUsecase>(
      GetAuthTokenUsecase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<RemoveAuthTokenUsecase>(
      RemoveAuthTokenUsecase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<SaveAuthTokenUsecase>(
      SaveAuthTokenUsecase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<GetUseridUsecase>(
      GetUseridUsecase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<SaveUseridUsecase>(
      SaveUseridUsecase(getIt<UserRepository>()),
    );

    //todo:--------------------------------------------------------------------
    getIt.registerSingleton<GetTodoUsecase>(
        GetTodoUsecase(getIt<TodoRepository>()));
    getIt.registerSingleton<InsertTodoUsecase>(
        InsertTodoUsecase(getIt<TodoRepository>()));
    getIt.registerSingleton<UpdateTodoUsecae>(
        UpdateTodoUsecae(getIt<TodoRepository>()));
    getIt.registerSingleton<DeleteTodoUsecase>(
      DeleteTodoUsecase(getIt<TodoRepository>()),
    );
  }
}
