import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../database/app_database.dart';
import '../network/network_info.dart';

class SyncService {
  final AppDatabase db;
  final Dio dio;
  final NetworkInfo networkInfo;

  SyncService({required this.db, required this.dio, required this.networkInfo});

  void start() {
    networkInfo.onStatusChanged.listen((results) async {
      if (!results.contains(ConnectivityResult.none)) {
        await flushQueue();
      }
    });
  }

  Future<void> flushQueue() async {
    final items = await db.pendingQueue();
    for (final item in items) {
      try {
        await dio.request(
          item.path,
          data: jsonDecode(item.body),
          options: Options(method: item.method),
        );
        await db.deleteQueueItem(item.id);
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
          await db.deleteQueueItem(item.id);
          continue;
        }
        break;
      }
    }
  }
}
