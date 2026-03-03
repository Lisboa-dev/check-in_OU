import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/student_form.dart';
import '../../domain/entities/trip_history_item.dart';
import '../controllers/app_providers.dart';

final studentControllerProvider = StateNotifierProvider<StudentController, AsyncValue<List<TripHistoryItem>>>((ref) {
  return StudentController(ref);
});

class StudentController extends StateNotifier<AsyncValue<List<TripHistoryItem>>> {
  final Ref ref;

  StudentController(this.ref) : super(const AsyncData([]));

  Future<void> saveForm(StudentForm form) async {
    final repo = await ref.read(repositoryProvider.future);
    await repo.saveForm(form);
  }

  Future<void> loadHistory(int studentId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(repositoryProvider.future);
      return repo.getStudentHistory(studentId: studentId);
    });
  }
}
