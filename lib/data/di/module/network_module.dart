import 'package:event_bus/event_bus.dart';
import 'package:todo_app/data/network/apis/user/user_api.dart';

import '../../../core/data/network/dio/configs/dio_configs.dart';
import '../../../core/data/network/dio/dio_client.dart';
import '../../../core/data/network/dio/interceptors/auth_interceptor.dart';
import '../../../core/data/network/dio/interceptors/logging_interceptor.dart';
import '../../../di/service_locator.dart';
import '../../../network/network.dart';
import '../../network/apis/posts/post_api.dart';
import '../../network/constants/endpoints.dart';
import '../../network/interceptors/error_interceptor.dart';
import '../../network/rest_client.dart';
import '../../sharedpref/shared_preference_helper.dart';

class NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    getIt.registerSingleton<NetworkInfoImpl>(NetworkInfoImpl());
    // event bus:---------------------------------------------------------------
    getIt.registerSingleton<EventBus>(EventBus());

    // interceptors:------------------------------------------------------------
    getIt.registerSingleton<LoggingInterceptor>(LoggingInterceptor());
    getIt.registerSingleton<ErrorInterceptor>(ErrorInterceptor(getIt()));
    getIt.registerSingleton<AuthInterceptor>(
      AuthInterceptor(
        accessToken: () async => await getIt<SharedPreferenceHelper>().authToken,
      ),
    );

    // rest client:-------------------------------------------------------------
    getIt.registerSingleton(RestClient());

    // dio:---------------------------------------------------------------------
    getIt.registerSingleton<DioConfigs>(
      const DioConfigs(
        baseUrl: Endpoints.baseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout:Endpoints.receiveTimeout,
      ),
    );
    getIt.registerSingleton<DioClient>(
      DioClient(dioConfigs: getIt())
        ..addInterceptors(
          [
            getIt<AuthInterceptor>(),
            getIt<ErrorInterceptor>(),
            getIt<LoggingInterceptor>(),
          ],
        ),
    );

    // api's:-------------------------------------------------------------------
    getIt.registerSingleton(UserApi(getIt<DioClient>(), getIt<SharedPreferenceHelper>()));
  }
}
