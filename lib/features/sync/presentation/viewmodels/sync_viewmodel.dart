import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/core/sync/sync_manager.dart';
import 'package:get_it/get_it.dart';

class SyncState {
  final bool isOnline;
  final int pendingSyncCount;
  final bool isSyncing;

  const SyncState({
    required this.isOnline,
    required this.pendingSyncCount,
    required this.isSyncing,
  });

  SyncState copyWith({
    bool? isOnline,
    int? pendingSyncCount,
    bool? isSyncing,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;
  bool _manualOverride = false;
  bool _manualOnlineValue = true;
  final SyncQueueManager _queueManager = GetIt.I<SyncQueueManager>();
  final SyncManager _syncManager = GetIt.I<SyncManager>();

  SyncNotifier() : super(const SyncState(isOnline: true, pendingSyncCount: 0, isSyncing: false)) {
    _initConnectivity();
    _refreshPendingCount();
  }

  void _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
    } catch (_) {}

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (!_manualOverride) {
        _updateStatus(results);
      }
    });
  }

  Future<void> _refreshPendingCount() async {
    final count = await _queueManager.getPendingCount();
    state = state.copyWith(pendingSyncCount: count);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    state = state.copyWith(isOnline: hasConnection);
    if (hasConnection) {
      syncLocalData();
    }
  }

  void toggleConnectionManual() {
    _manualOverride = true;
    _manualOnlineValue = !state.isOnline;
    state = state.copyWith(isOnline: _manualOnlineValue);
    if (_manualOnlineValue) {
      syncLocalData();
    }
  }

  Future<void> queueAction({
    required String actionType,
    required String payloadJson,
  }) async {
    await _queueManager.queueAction(actionType: actionType, payloadJson: payloadJson);
    await _refreshPendingCount();
  }

  Future<void> syncLocalData() async {
    await _refreshPendingCount();
    if (state.pendingSyncCount == 0 || state.isSyncing || !state.isOnline) return;

    state = state.copyWith(isSyncing: true);
    await _syncManager.triggerSync();
    await _refreshPendingCount();
    state = state.copyWith(isSyncing: false);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier();
});
