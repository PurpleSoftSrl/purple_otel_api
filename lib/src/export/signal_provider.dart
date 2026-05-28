import '../common/export_result.dart' show ExportResult;
import '../logs/logger.dart' show Logger, LogRecord;
import '../metrics/meter.dart' show Meter;
import '../metrics/metric.dart' show Metric;
import '../trace/tracer.dart' show Tracer, Span;

abstract interface class SignalProvider<T> {
  T get(String name, {String? version, String? schemaUrl});
  Future<void> forceFlush();
  Future<void> shutdown();
}

abstract interface class SignalExporter<T> {
  Future<ExportResult> export(List<T> items);
  Future<void> shutdown();
  Future<void> forceFlush();
}

typedef LoggerProvider = SignalProvider<Logger>;
typedef TracerProvider = SignalProvider<Tracer>;
typedef MeterProvider = SignalProvider<Meter>;
typedef LogRecordExporter = SignalExporter<LogRecord>;
typedef SpanExporter = SignalExporter<Span>;
typedef MetricExporter = SignalExporter<Metric>;
