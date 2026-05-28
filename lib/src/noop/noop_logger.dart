import '../logs/logger.dart' show Logger, LogRecord;

final class NoopLogger implements Logger {
  const NoopLogger();

  @override
  void emit(LogRecord record) {}
}
