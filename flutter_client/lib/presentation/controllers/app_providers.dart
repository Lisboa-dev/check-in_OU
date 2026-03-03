import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/security/token_storage.dart';
import '../../data/local_ds/checkin_local_ds.dart';
import '../../data/remote_ds/checkin_remote_ds.dart';
import '../../data/repositories/checkin_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfo(Connectivity()));

final apiClientProvider = FutureProvider<ApiClient>((ref) async {
  return ApiClient.create(
    db: ref.read(databaseProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
});

final repositoryProvider = FutureProvider<CheckinRepository>((ref) async {
  final apiClient = await ref.watch(apiClientProvider.future);
  final local = CheckinLocalDataSource(ref.read(databaseProvider));
  final remote = CheckinRemoteDataSource(apiClient.dio);
  return CheckinRepository(
    remote: remote,
    local: local,
    networkInfo: ref.read(networkInfoProvider),
  );
});
