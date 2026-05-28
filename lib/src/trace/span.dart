import '../common/attributes.dart';
import '../common/identifiers.dart';
import 'span_state.dart';

final class SpanContext {
  final TraceId traceId;
  final SpanId spanId;
  final TraceFlags traceFlags;
  final TraceState traceState;
  final bool isRemote;

  const SpanContext({
    required this.traceId,
    required this.spanId,
    required this.traceFlags,
    this.traceState = const TraceState.empty(),
    this.isRemote = false,
  });

  bool get isValid => traceId.isValid && spanId.isValid;
  bool get isSampled => traceFlags.isSampled;

  @override
  bool operator ==(Object other) =>
      other is SpanContext &&
      other.traceId == traceId &&
      other.spanId == spanId &&
      other.traceFlags == traceFlags;

  @override
  int get hashCode => Object.hash(traceId, spanId, traceFlags);

  @override
  String toString() =>
      'SpanContext(${traceId.toShortString()}:${spanId.toShortString()})';
}

final class SpanLink {
  final SpanContext spanContext;
  final Attributes? attributes;

  const SpanLink({required this.spanContext, this.attributes});

  @override
  bool operator ==(Object other) =>
      other is SpanLink &&
      other.spanContext == spanContext &&
      other.attributes == attributes;

  @override
  int get hashCode => Object.hash(spanContext, attributes);
}

final class SpanEvent {
  final String name;
  final DateTime timestamp;
  final Attributes? attributes;

  const SpanEvent({
    required this.name,
    required this.timestamp,
    this.attributes,
  });

  @override
  bool operator ==(Object other) =>
      other is SpanEvent &&
      other.name == name &&
      other.timestamp == timestamp &&
      other.attributes == attributes;

  @override
  int get hashCode => Object.hash(name, timestamp, attributes);
}
