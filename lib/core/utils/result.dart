import 'package:flutter/foundation.dart';

@immutable
sealed class Result<S, F extends Failure> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is FailureResult<S, F>;

  S? get successOrNull => switch (this) {
        Success(value: final v) => v,
        FailureResult() => null,
      };

  F? get failureOrNull => switch (this) {
        Success() => null,
        FailureResult(error: final e) => e,
      };

  R fold<R>({
    required R Function(S value) onSuccess,
    required R Function(F error) onFailure,
  }) =>
      switch (this) {
        Success(value: final v) => onSuccess(v),
        FailureResult(error: final e) => onFailure(e),
      };
}

class Success<S, F extends Failure> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

class FailureResult<S, F extends Failure> extends Result<S, F> {
  final F error;
  const FailureResult(this.error);
}

@immutable
abstract class Failure {
  final String message;
  final dynamic originalError;

  const Failure(this.message, [this.originalError]);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.originalError]);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, [this.statusCode, super.originalError]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.originalError]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.originalError]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, [super.originalError]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.originalError]);
}

class CollaboratorNotFoundFailure extends Failure {
  const CollaboratorNotFoundFailure(super.message, [super.originalError]);
}

