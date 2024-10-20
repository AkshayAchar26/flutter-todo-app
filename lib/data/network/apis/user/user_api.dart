import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/data/network/dio/dio_client.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../sharedpref/shared_preference_helper.dart';
import '../../constants/endpoints.dart';

class UserApi {
  final DioClient _dioClient;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  UserApi(this._dioClient,this._sharedPreferenceHelper);

  Future<User?> createUserInDB() async {
    try {
      final token = await _sharedPreferenceHelper.authToken;
      final res = await _dioClient.dio.get(Endpoints.profileRoute,options: Options(
          headers: {
            "authorization" : "Token ${token}"
          }
      ),);
      if (res.statusCode == 200) {
        return User.fromMap(res.data["data"]);
      } else {
        return null;
      }

    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}