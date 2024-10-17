// import 'dart:async';

// import '../../../../core/data/network/dio/dio_client.dart';
// import '../../../../domain/entity/post/post_list.dart';
// import '../../constants/endpoints.dart';
// import '../../rest_client.dart';


// class PostApi {
//   // dio instance
//   final DioClient _dioClient;

//   // rest-client instance
//   final RestClient _restClient;

//   // injecting dio instance
//   PostApi(this._dioClient, this._restClient);

//   /// Returns list of post in response
//   Future<PostList> getPosts() async {
//     try {
//       final res = await _dioClient.dio.get(Endpoints.getPosts);
//       return PostList.fromJson(res.data);
//     } catch (e) {
//       print(e.toString());
//       throw e;
//     }
//   }

//   /// sample api call with default rest client
// //   Future<PostList> getPosts() async {
// //     try {
// //       final res = await _restClient.get(Endpoints.getPosts);
// //       return PostList.fromJson(res.data);
// //     } catch (e) {
// //       print(e.toString());
// //       throw e;
// //     }
// //   }
// }
