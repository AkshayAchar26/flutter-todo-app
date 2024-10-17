import 'dart:async';

import 'package:todo_app/domain/usecase/todo/delete_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/get_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/insert_todo_usecase.dart';
import 'package:todo_app/domain/usecase/todo/update_todo_usecae.dart';
import 'package:todo_app/domain/usecase/user/remove_auth_token_usecase.dart';
import 'package:todo_app/domain/usecase/user/save_auth_token_usecase.dart';
import 'package:todo_app/domain/usecase/user/save_userId_usecase.dart';
import 'package:todo_app/presentation/todo/store/todo_store.dart';

import '../../../core/stores/error/error_store.dart';
import '../../../core/stores/form/form_store.dart';
import '../../../di/service_locator.dart';
import '../../../domain/repository/setting/setting_repository.dart';
import '../../../domain/usecase/user/is_logged_in_usecase.dart';
import '../../../domain/usecase/user/login_usecase.dart';
import '../../../domain/usecase/user/save_login_in_status_usecase.dart';
import '../../home/store/language/language_store.dart';
import '../../home/store/theme/theme_store.dart';
import '../../login/store/login_store.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());
    getIt.registerFactory(() => FormErrorStore());
    getIt.registerFactory(
      () => FormStore(getIt<FormErrorStore>(), getIt<ErrorStore>()),
    );

    // stores:------------------------------------------------------------------
    getIt.registerSingleton<UserStore>(
      UserStore(
          getIt<IsLoggedInUseCase>(),
          getIt<SaveLoginStatusUseCase>(),
          getIt<LoginUseCase>(),
          getIt<FormErrorStore>(),
          getIt<RemoveAuthTokenUsecase>(),
          getIt<SaveAuthTokenUsecase>(),
          getIt<SaveUseridUsecase>(),
          getIt<ErrorStore>()),
    );

    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<TodoStore>(TodoStore(
        getIt<GetTodoUsecase>(),
        getIt<InsertTodoUsecase>(),
        getIt<UpdateTodoUsecae>(),
        getIt<DeleteTodoUsecase>()));
  }
}
