import '../export/signal_provider.dart' show LoggerProvider;
import '../logs/logger.dart' show Logger;
import 'noop_logger.dart' show NoopLogger;

/// A no-op implementation of [LoggerProvider] that returns [NoopLogger].
///
/// All methods are no-ops. Use this provider when logging is disabled or
/// when no real logger is available.
final class NoopLoggerProvider implements LoggerProvider {
  const NoopLoggerProvider();

  @override
  Logger get(String name, {String? version, String? schemaUrl}) =>
      const NoopLogger();

  @override
  Future<void> forceFlush() async {}

  @override
  Future<void> shutdown() async {}
}
