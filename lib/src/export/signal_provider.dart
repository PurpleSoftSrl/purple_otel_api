import '../common/export_result.dart' show ExportResult;
import '../logs/logger.dart' show Logger, LogRecord;
import '../metrics/meter.dart' show Meter;
import '../metrics/metric.dart' show Metric;
import '../trace/tracer.dart' show Tracer, Span;

/// Provides named instances of a signal-specific type.
///
/// [SignalProvider] is the base contract for [TracerProvider],
/// [LoggerProvider], and [MeterProvider]. Each provides a named instance
/// of the signal type [T] via [get], and supports [forceFlush] and
/// [shutdown] for graceful teardown.
///
/// The optional [version] and [schemaUrl] parameters in [get] identify
/// the instrumentation scope.
abstract interface class SignalProvider<T> {
  /// Returns a named instance of type [T].
  ///
  /// The [version] and [schemaUrl] identify the instrumentation scope.
  T get(String name, {String? version, String? schemaUrl});

  /// Flushes any pending data for all instances.
  Future<void> forceFlush();

  /// Shuts down the provider, releasing resources and flushing pending
  /// data before completing.
  Future<void> shutdown();
}

/// Exports a batch of signal items.
///
/// [SignalExporter] is the base contract for [SpanExporter],
/// [LogRecordExporter], and [MetricExporter]. Each receives a batch of
/// items via [export] and supports [forceFlush] and [shutdown].
abstract interface class SignalExporter<T> {
  /// Exports a list of [items] and returns an [ExportResult].
  Future<ExportResult> export(List<T> items);

  /// Shuts down the exporter, releasing resources before completing.
  Future<void> shutdown();

  /// Flushes any pending exports.
  Future<void> forceFlush();
}

/// A [SignalProvider] for [Logger] instances.
typedef LoggerProvider = SignalProvider<Logger>;

/// A [SignalProvider] for [Tracer] instances.
typedef TracerProvider = SignalProvider<Tracer>;

/// A [SignalProvider] for [Meter] instances.
typedef MeterProvider = SignalProvider<Meter>;

/// A [SignalExporter] for [LogRecord] batches.
typedef LogRecordExporter = SignalExporter<LogRecord>;

/// A [SignalExporter] for [Span] batches.
typedef SpanExporter = SignalExporter<Span>;

/// A [SignalExporter] for [Metric] batches.
typedef MetricExporter = SignalExporter<Metric>;
