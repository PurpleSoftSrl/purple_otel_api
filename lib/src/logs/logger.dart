import '../common/attribute_value.dart' show AttributeValue;
import '../common/attributes.dart' show Attributes;
import '../common/identifiers.dart' show TraceId, SpanId, TraceFlags;
import '../context/context.dart' show Context;

/// Numeric severity levels for [LogRecord]s, following the OpenTelemetry
/// log data model.
///
/// Each level has an associated [value] from 1 (least severe) to 24 (most
/// severe). The named levels map to ranges: [trace] 1-4, [debug] 5-8,
/// [info] 9-12, [warn] 13-16, [error] 17-20, [fatal] 21-24.
enum Severity {
  /// Trace level 1 — most fine-grained diagnostic information.
  trace(1),
  trace2(2),
  trace3(3),
  trace4(4),

  /// Debug level 5-8 — debugging information.
  debug(5),
  debug2(6),
  debug3(7),
  debug4(8),

  /// Informational level 9-12 — general operational messages.
  info(9),
  info2(10),
  info3(11),
  info4(12),

  /// Warning level 13-16 — potential issues that do not prevent operation.
  warn(13),
  warn2(14),
  warn3(15),
  warn4(16),

  /// Error level 17-20 — errors that should be investigated.
  error(17),
  error2(18),
  error3(19),
  error4(20),

  /// Fatal level 21-24 — unrecoverable errors requiring immediate attention.
  fatal(21),
  fatal2(22),
  fatal3(23),
  fatal4(24);

  /// The numeric value of this severity level per the OpenTelemetry spec.
  final int value;
  const Severity(this.value);

  /// Returns the [Severity] corresponding to the given numeric [number].
  ///
  /// Falls back to [Severity.info] if no exact match is found.
  static Severity fromNumber(int number) => Severity.values
      .firstWhere((s) => s.value == number, orElse: () => Severity.info);
}

/// A readable log record emitted by a [Logger].
///
/// [LogRecord] instances are created by [Logger] implementations and passed
/// through the [LogRecordProcessor] pipeline to [LogRecordExporter]s.
///
/// Records include a [timestamp], [observedTimestamp], [severityNumber],
/// [body], and optional trace context fields ([traceId], [spanId],
/// [traceFlags]) for correlation with spans.
class LogRecord {
  /// The time the event occurred.
  final DateTime timestamp;

  /// The time the event was observed by the logging system.
  final DateTime observedTimestamp;

  /// The numeric [Severity] of this record.
  final Severity severityNumber;

  /// An optional human-readable severity label (e.g., "ERROR").
  final String? severityText;

  /// The log body as an [AttributeValue].
  final AttributeValue body;

  /// Structured attributes providing additional context.
  final Attributes attributes;

  /// The [TraceId] of the associated span, if any.
  final TraceId? traceId;

  /// The [SpanId] of the associated span, if any.
  final SpanId? spanId;

  /// The [TraceFlags] of the associated span, if any.
  final TraceFlags? traceFlags;

  /// The number of attributes that were dropped due to limits.
  final int droppedAttributesCount;

  /// Creates a [LogRecord] with the given parameters.
  ///
  /// The [attributes] default to [Attributes.empty] if not provided.
  /// The [droppedAttributesCount] defaults to 0.
  const LogRecord({
    required this.timestamp,
    required this.observedTimestamp,
    required this.severityNumber,
    this.severityText,
    required this.body,
    this.attributes = const Attributes.empty(),
    this.traceId,
    this.spanId,
    this.traceFlags,
    this.droppedAttributesCount = 0,
  });
}

/// Emits [LogRecord]s to the logging pipeline.
///
/// A [Logger] is obtained from a [LoggerProvider] and is used to emit
/// [LogRecord]s. Implementations forward records to the configured
/// [LogRecordProcessor] pipeline.
abstract interface class Logger {
  /// Emits a [record] to the logging pipeline.
  void emit(LogRecord record);
}

/// Processes [LogRecord]s for export.
///
/// [LogRecordProcessor] acts as a pipeline hook for emitted log records.
/// Call [forceFlush] to flush pending records and [shutdown] to permanently
/// stop the processor.
abstract interface class LogRecordProcessor {
  /// Called when a [record] is emitted with the given [context].
  void onEmit(Context context, LogRecord record);

  /// Flushes any pending records, returning a [Future] that completes when
  /// the flush is done.
  Future<void> forceFlush();

  /// Shuts down the processor, releasing resources and flushing pending
  /// records before completing.
  Future<void> shutdown();
}
