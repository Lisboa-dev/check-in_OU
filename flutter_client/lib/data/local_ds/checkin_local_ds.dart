import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart';
import '../models/student_form_dto.dart';
import '../models/trip_history_dto.dart';

class CheckinLocalDataSource {
  final AppDatabase db;

  CheckinLocalDataSource(this.db);

  Future<void> saveForm(StudentFormDto dto) async {
    await db.upsertStudentForm(
      LocalStudentFormsCompanion.insert(
        id: dto.id ?? 1,
        university: dto.university,
        route: dto.route,
        schedule: dto.schedule,
        qrCodeBase64: drift.Value(dto.qrCodeBase64),
      ),
    );
  }

  Future<void> cacheHistory(int studentId, List<TripHistoryDto> history) async {
    await db.saveTripHistoryBatch(
      history
          .map(
            (e) => LocalTripHistoryCompanion.insert(
              id: e.presenceId,
              studentId: studentId,
              driverId: drift.Value(e.driverId),
              tripLogId: drift.Value(e.tripLogId),
              date: e.scannedAt,
              status: const drift.Value('synced'),
            ),
          )
          .toList(),
    );
  }

  Future<List<LocalTripHistoryData>> getOfflineHistory(int studentId) {
    return db.getHistoryByStudent(studentId);
  }
}
