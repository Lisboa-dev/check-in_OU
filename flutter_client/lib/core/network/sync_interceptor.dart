import 'dart:convert';

import 'package:dio/dio.dart';

import '../database/app_database.dart';

class SyncInterceptor extends Interceptor {
  final AppDatabase db;

  SyncInterceptor(this.db);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isOffline = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.unknown;

    if (isOffline && err.requestOptions.method != 'GET') {
      final body = jsonEncode(err.requestOptions.data ?? {});
      await db.enqueue(
        method: err.requestOptions.method,
        path: err.requestOptions.path,
        body: body,
      );

      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 202,
          data: {
            'queued': true,
            'message': 'Sem conexão. Requisição adicionada à fila de sincronização.',
          },
        ),
      );
      return;
    }

    handler.next(err);
  }
}
