import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class LocalStudentForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get university => text()();
  TextColumn get route => text()();
  TextColumn get schedule => text()();
  TextColumn get qrCodeBase64 => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class LocalTripHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer()();
  IntColumn get driverId => integer().nullable()();
  IntColumn get tripLogId => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('synced'))();
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get method => text()();
  TextColumn get path => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [LocalStudentForms, LocalTripHistory, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> enqueue({required String method, required String path, required String body}) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(method: method, path: path, body: body),
    );
  }

  Future<List<SyncQueueData>> pendingQueue() {
    return (select(syncQueue)..orderBy([(t) => OrderingTerm.asc(t.timestamp)])).get();
  }

  Future<int> deleteQueueItem(int id) {
    return (delete(syncQueue)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> upsertStudentForm(LocalStudentFormsCompanion form) async {
    await into(localStudentForms).insertOnConflictUpdate(form);
  }

  Future<List<LocalTripHistoryData>> getHistoryByStudent(int studentId) {
    return (select(localTripHistory)
          ..where((t) => t.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<void> saveTripHistoryBatch(List<LocalTripHistoryCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localTripHistory, rows);
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'checkin_ou',
    native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
