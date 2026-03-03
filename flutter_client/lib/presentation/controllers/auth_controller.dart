import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AuthController(this.ref) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(repositoryProvider.future);
      final token = await repo.login(email, password);
      await ref.read(tokenStorageProvider).save(token);
    });
  }
}
