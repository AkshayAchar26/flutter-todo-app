import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/local/datasources/todo/todo_datasource.dart';
import 'package:todo_app/data/local/datasources/user/user_datasource.dart';

import '../../../core/data/local/sembast/sembast_client.dart';
import '../../../di/service_locator.dart';
import '../../local/constants/db_constants.dart';
import '../../sharedpref/shared_preference_helper.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    // preference manager:------------------------------------------------------
    getIt.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);
    getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()),
    );

    // database:----------------------------------------------------------------

    getIt.registerSingletonAsync<SembastClient>(
      () async => SembastClient.provideDatabase(
        databaseName: DBConstants.DB_NAME,
        databasePath: kIsWeb
            ? "/assets/db"
            : (await getApplicationDocumentsDirectory()).path,
      ),
    );

    // data sources:------------------------------------------------------------
    getIt.registerSingleton(
        UserDatasource(await getIt.getAsync<SembastClient>()));
    getIt.registerSingleton(
        TodoDatasource(await getIt.getAsync<SembastClient>()));
  }
}
