import '../common/attribute_value.dart' show AttributeValue;
import '../common/attributes.dart' show Attributes;
import '../common/identifiers.dart' show TraceId, SpanId, TraceFlags;
import '../context/context.dart' show Context;

enum Severity {
  trace(1), trace2(2), trace3(3), trace4(4),
  debug(5), debug2(6), debug3(7), debug4(8),
  info(9), info2(10), info3(11), info4(12),
  warn(13), warn2(14), warn3(15), warn4(16),
  error(17), error2(18), error3(19), error4(20),
  fatal(21), fatal2(22), fatal3(23), fatal4(24);

  final int value;
  const Severity(this.value);

  static Severity fromNumber(int number) =>
      Severity.values.firstWhere((s) => s.value == number, orElse: () => Severity.info);
}

class LogRecord {
  final DateTime timestamp;
  final DateTime observedTimestamp;
  final Severity severityNumber;
  final String? severityText;
  final AttributeValue body;
  final Attributes attributes;
  final TraceId? traceId;
  final SpanId? spanId;
  final TraceFlags? traceFlags;
  final int droppedAttributesCount;

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

abstract interface class Logger {
  void emit(LogRecord record);
}

abstract interface class LogRecordProcessor {
  void onEmit(Context context, LogRecord record);

  Future<void> forceFlush();

  Future<void> shutdown();
}
