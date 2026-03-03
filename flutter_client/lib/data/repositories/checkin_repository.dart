import '../../core/network/network_info.dart';
import '../../domain/entities/student_form.dart';
import '../../domain/entities/trip_history_item.dart';
import '../local_ds/checkin_local_ds.dart';
import '../models/student_form_dto.dart';
import '../remote_ds/checkin_remote_ds.dart';

class CheckinRepository {
  final CheckinRemoteDataSource remote;
  final CheckinLocalDataSource local;
  final NetworkInfo networkInfo;

  CheckinRepository({required this.remote, required this.local, required this.networkInfo});

  Future<String> login(String email, String password) => remote.login(email, password);

  Future<StudentForm> saveForm(StudentForm form) async {
    final dto = StudentFormDto(
      id: form.id,
      university: form.university,
      route: form.route,
      schedule: form.schedule,
      qrCodeBase64: form.qrCodeBase64,
    );

    final saved = await remote.upsertForm(dto);
    await local.saveForm(saved);

    return StudentForm(
      id: saved.id,
      university: saved.university,
      route: saved.route,
      schedule: saved.schedule,
      qrCodeBase64: saved.qrCodeBase64,
    );
  }

  Future<List<TripHistoryItem>> getStudentHistory({required int studentId}) async {
    if (await networkInfo.isConnected) {
      final remoteHistory = await remote.getMyHistory();
      await local.cacheHistory(studentId, remoteHistory);
      return remoteHistory
          .map((e) => TripHistoryItem(id: e.presenceId, scannedAt: e.scannedAt, status: 'synced'))
          .toList();
    }

    final offline = await local.getOfflineHistory(studentId);
    return offline.map((e) => TripHistoryItem(id: e.id, scannedAt: e.date, status: e.status)).toList();
  }

  Future<void> scanStudent({required int studentId, required String qrPayload}) {
    return remote.scanStudent(studentId: studentId, qrPayload: qrPayload);
  }

  Future<Map<String, dynamic>> getDashboard() => remote.getDashboard();
}
