enum ExportResultCode {
  success,
  failureRetryable,
  failureNotRetryable,
}

final class ExportResult {
  final ExportResultCode code;
  final String? errorMessage;
  final int droppedCount;

  const ExportResult._(this.code, {this.errorMessage, this.droppedCount = 0});

  factory ExportResult.success() =>
      const ExportResult._(ExportResultCode.success);

  factory ExportResult.failureRetryable(String message) =>
      ExportResult._(ExportResultCode.failureRetryable, errorMessage: message);

  factory ExportResult.failureNotRetryable(String message, {int dropped = 0}) =>
      ExportResult._(ExportResultCode.failureNotRetryable,
          errorMessage: message, droppedCount: dropped);

  bool get isSuccess => code == ExportResultCode.success;
  bool get isRetryable => code == ExportResultCode.failureRetryable;
  bool get isNotRetryable => code == ExportResultCode.failureNotRetryable;
}
