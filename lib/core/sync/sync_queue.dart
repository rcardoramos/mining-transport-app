import 'package:drift/drift.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:get_it/get_it.dart';

class SyncQueueManager {
  final AppDatabase _db = GetIt.I<AppDatabase>();

  Future<void> queueAction({
    required String actionType,
    required String payloadJson,
  }) async {
    await _db.into(_db.syncQueue).insert(
      SyncQueueCompanion.insert(
        actionType: actionType,
        payloadJson: payloadJson,
        status: 'Pending',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<List<SyncQueueData>> getPendingActions() async {
    return (_db.select(_db.syncQueue)
          ..where((t) => t.status.equals('Pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> getPendingCount() async {
    final list = await getPendingActions();
    return list.length;
  }

  Future<void> markAsSynced(int id) async {
    await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
      const SyncQueueCompanion(
        status: Value('Synced'),
      ),
    );
  }

  Future<void> markAsFailed(int id, String error, int attempts) async {
    await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(
        status: const Value('Error'),
        errorDetails: Value(error),
        attempts: Value(attempts),
      ),
    );
  }

  Future<List<SyncQueueData>> getAllActions() async {
    return (_db.select(_db.syncQueue)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> clearQueue() async {
    await _db.delete(_db.syncQueue).go();
  }
}
