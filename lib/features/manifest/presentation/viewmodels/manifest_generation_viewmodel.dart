import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/time/clock.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';
import 'package:mining_transport_app/features/manifest/domain/repositories/manifest_repository.dart';
import 'package:mining_transport_app/features/manifest/domain/usecases/generate_manifest_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';

enum ManifestUiPhase {
  idle,
  generatingManifest,
  manifestReady,
  manifestError,
}

class ManifestUiState {
  const ManifestUiState({
    this.phase = ManifestUiPhase.idle,
    this.errorMessage,
    this.lastResult,
  });

  final ManifestUiPhase phase;
  final String? errorMessage;
  final ManifestGenerationResult? lastResult;

  bool get isGenerating => phase == ManifestUiPhase.generatingManifest;

  ManifestUiState copyWith({
    ManifestUiPhase? phase,
    String? errorMessage,
    ManifestGenerationResult? lastResult,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return ManifestUiState(
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastResult: clearResult ? null : (lastResult ?? this.lastResult),
    );
  }
}

/// ViewModel auxiliar: genera manifiesto sin mutar el estado del viaje.
class ManifestGenerationViewModel extends StateNotifier<ManifestUiState> {
  ManifestGenerationViewModel(this._ref) : super(const ManifestUiState());

  final Ref _ref;

  Future<ManifestGenerationResult?> generate({
    required TripEntity trip,
    required String driverName,
    List<PassengerEntity>? localPassengersFallback,
  }) async {
    if (state.isGenerating) return null;

    state = state.copyWith(
      phase: ManifestUiPhase.generatingManifest,
      clearError: true,
    );

    final useCase = GenerateManifestUseCase(
      GetIt.I<ManifestRepository>(),
      GetIt.I<Clock>(),
    );

    final result = await useCase.execute(
      trip: trip,
      driverName: driverName,
      isOnline: _ref.read(syncProvider).isOnline,
      localPassengersFallback: localPassengersFallback,
    );

    if (result.isFailure) {
      GetIt.I<AppLogger>().e(
        'Error generando manifiesto: ${result.failureOrNull?.message}',
        result.failureOrNull?.originalError,
      );
      state = state.copyWith(
        phase: ManifestUiPhase.manifestError,
        errorMessage: result.failureOrNull?.message ??
            'No pudimos generar el manifiesto. Inténtelo nuevamente.',
      );
      return null;
    }

    final value = result.successOrNull!;
    state = state.copyWith(
      phase: ManifestUiPhase.manifestReady,
      lastResult: value,
      clearError: true,
    );
    return value;
  }

  void reset() {
    state = const ManifestUiState();
  }
}

final manifestGenerationViewModelProvider =
    StateNotifierProvider.autoDispose<ManifestGenerationViewModel, ManifestUiState>(
  (ref) => ManifestGenerationViewModel(ref),
);
