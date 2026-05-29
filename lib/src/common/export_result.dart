/// The status code of an export operation.
enum ExportResultCode {
  /// The export completed successfully.
  success,

  /// The export failed but may succeed if retried (transient error).
  failureRetryable,

  /// The export failed and should not be retried (permanent error).
  failureNotRetryable,
}

/// The result of an export operation performed by a [SignalExporter].
///
/// Constructed via named factories:
/// - [ExportResult.success()]: the export succeeded
/// - [ExportResult.failureRetryable()]: transient failure, retry may succeed
/// - [ExportResult.failureNotRetryable()]: permanent failure, do not retry
///
/// Use [isSuccess], [isRetryable], and [isNotRetryable] to check the
/// result status.
final class ExportResult {
  /// The [ExportResultCode] for this result.
  final ExportResultCode code;

  /// An optional human-readable error message.
  final String? errorMessage;

  /// The number of items dropped during the export.
  final int droppedCount;

  const ExportResult._(this.code, {this.errorMessage, this.droppedCount = 0});

  /// Creates a success result.
  factory ExportResult.success() =>
      const ExportResult._(ExportResultCode.success);

  /// Creates a retryable failure result with the given error [message].
  factory ExportResult.failureRetryable(String message) =>
      ExportResult._(ExportResultCode.failureRetryable, errorMessage: message);

  /// Creates a non-retryable failure result with the given error [message]
  /// and optional [dropped] count.
  factory ExportResult.failureNotRetryable(String message, {int dropped = 0}) =>
      ExportResult._(ExportResultCode.failureNotRetryable,
          errorMessage: message, droppedCount: dropped);

  /// Whether the export was successful.
  bool get isSuccess => code == ExportResultCode.success;

  /// Whether the failure may be retried.
  bool get isRetryable => code == ExportResultCode.failureRetryable;

  /// Whether the failure should not be retried.
  bool get isNotRetryable => code == ExportResultCode.failureNotRetryable;
}
