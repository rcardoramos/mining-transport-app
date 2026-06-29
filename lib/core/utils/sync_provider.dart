import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  SyncNotifier() : super(const SyncState(isOnline: true, pendingSyncCount: 0, isSyncing: false)) {
    _initConnectivity();
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

  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    state = state.copyWith(isOnline: hasConnection);
  }

  void toggleConnectionManual() {
    _manualOverride = true;
    _manualOnlineValue = !state.isOnline;
    state = state.copyWith(isOnline: _manualOnlineValue);
  }

  void incrementPendingSync() {
    if (!state.isOnline) {
      state = state.copyWith(pendingSyncCount: state.pendingSyncCount + 1);
    }
  }

  void setPendingSyncCount(int count) {
    state = state.copyWith(pendingSyncCount: count);
  }

  Future<void> syncLocalData() async {
    if (state.pendingSyncCount == 0 || state.isSyncing || !state.isOnline) return;

    state = state.copyWith(isSyncing: true);
    // Simular retraso de llamada de red de sincronización
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isSyncing: false,
      pendingSyncCount: 0,
    );
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
