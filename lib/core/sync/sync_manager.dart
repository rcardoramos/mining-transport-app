import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/core/sync/sync_worker.dart';
import 'package:get_it/get_it.dart';

class SyncManager {
  final SyncQueueManager _queueManager = GetIt.I<SyncQueueManager>();
  final SyncWorker _worker = GetIt.I<SyncWorker>();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  void initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (hasConnection) {
        triggerSync();
      }
    });
  }

  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _worker.processQueue();
    } catch (_) {}
    _isSyncing = false;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
