import 'package:dio/dio.dart';

import '../database/app_database.dart';
import '../security/token_storage.dart';
import 'sync_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  static Future<ApiClient> create({required AppDatabase db, required TokenStorage tokenStorage}) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.read();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(SyncInterceptor(db));
    return ApiClient._(dio);
  }
}
