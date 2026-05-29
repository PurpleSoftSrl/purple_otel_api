import '../logs/logger.dart' show Logger, LogRecord;

/// A no-op implementation of [Logger] that discards all [LogRecord]s.
///
/// The [emit] method is a no-op. Use this logger when logging is disabled.
final class NoopLogger implements Logger {
  const NoopLogger();

  @override
  void emit(LogRecord record) {}
}
