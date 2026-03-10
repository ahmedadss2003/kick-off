// import 'package:dio/dio.dart';
// import 'package:kickoff/core/utils/app_session.dart';

// class DioClient {
//   static final Dio dio = Dio();

//   static void init() {
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           /// add token automatically
//           if (AppSession.token != null) {
//             options.headers["Authorization"] = "Bearer ${AppSession.token}";
//           }

//           options.headers["Accept"] = "application/json";

//           return handler.next(options);
//         },
//       ),
//     );
//   }
// }
