import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/core/sync/sync_manager.dart';
import 'package:get_it/get_it.dart';

class MockSyncQueueManager extends Mock implements SyncQueueManager {}
class MockSyncManager extends Mock implements SyncManager {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSyncQueueManager mockQueueManager;
  late MockSyncManager mockSyncManager;

  setUpAll(() {
    mockQueueManager = MockSyncQueueManager();
    mockSyncManager = MockSyncManager();

    final locator = GetIt.instance;
    if (locator.isRegistered<SyncQueueManager>()) {
      locator.unregister<SyncQueueManager>();
    }
    if (locator.isRegistered<SyncManager>()) {
      locator.unregister<SyncManager>();
    }
    locator.registerSingleton<SyncQueueManager>(mockQueueManager);
    locator.registerSingleton<SyncManager>(mockSyncManager);
  });

  group('SyncNotifier Tests', () {
    test('should load pending count on initialization', () async {
      when(() => mockQueueManager.getPendingCount()).thenAnswer((_) async => 5);

      final notifier = SyncNotifier();
      
      // Let it process initialization
      await Future.delayed(const Duration(milliseconds: 10));

      expect(notifier.state.pendingSyncCount, 5);
      verify(() => mockQueueManager.getPendingCount()).called(1);
    });

    test('queueAction should add action and reload pending count', () async {
      when(() => mockQueueManager.getPendingCount()).thenAnswer((_) async => 1);
      when(() => mockQueueManager.queueAction(
            actionType: any(named: 'actionType'),
            payloadJson: any(named: 'payloadJson'),
          )).thenAnswer((_) async => {});

      final notifier = SyncNotifier();
      await notifier.queueAction(actionType: 'TEST', payloadJson: '{}');

      expect(notifier.state.pendingSyncCount, 1);
    });
  });
}
