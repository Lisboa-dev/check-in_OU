import '../../data/repositories/checkin_repository.dart';
import '../entities/trip_history_item.dart';

class GetStudentHistoryUseCase {
  final CheckinRepository repository;

  GetStudentHistoryUseCase(this.repository);

  Future<List<TripHistoryItem>> call(int studentId) {
    return repository.getStudentHistory(studentId: studentId);
  }
}
