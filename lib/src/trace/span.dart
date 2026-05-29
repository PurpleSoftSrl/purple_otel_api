import '../common/attributes.dart';
import '../common/identifiers.dart';
import 'span_state.dart';

/// The immutable context identifying a [Span] within a trace.
///
/// A [SpanContext] carries the [traceId], [spanId], [traceFlags], and
/// optionally a [traceState]. It is propagated across process boundaries
/// via W3C Trace Context headers.
///
/// [isValid] returns `true` when both [traceId] and [spanId] are valid
/// (non-zero). [isSampled] checks the sampled flag in [traceFlags].
final class SpanContext {
  /// The [TraceId] of the trace this span belongs to.
  final TraceId traceId;

  /// The [SpanId] uniquely identifying this span within the trace.
  final SpanId spanId;

  /// The [TraceFlags] for this span.
  final TraceFlags traceFlags;

  /// The W3C [TraceState] associated with this span.
  final TraceState traceState;

  /// Whether this context originated from a remote process.
  ///
  /// When `true`, the span was created on a remote service and propagated
  /// to this process.
  final bool isRemote;

  /// Creates a [SpanContext] with the given parameters.
  ///
  /// The [traceState] defaults to [TraceState.empty] and [isRemote] defaults
  /// to `false`.
  const SpanContext({
    required this.traceId,
    required this.spanId,
    required this.traceFlags,
    this.traceState = const TraceState.empty(),
    this.isRemote = false,
  });

  /// Whether both the [traceId] and [spanId] are valid (non-zero).
  bool get isValid => traceId.isValid && spanId.isValid;

  /// Whether the sampled flag is set in [traceFlags].
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

/// A link to a causally-related [SpanContext].
///
/// [SpanLink]s connect a span to others that are not its direct parent or
/// child. They are often used to correlate spans in batching or async
/// scenarios. Each link references a [spanContext] and may carry optional
/// [attributes].
final class SpanLink {
  /// The [SpanContext] of the related span.
  final SpanContext spanContext;

  /// Optional attributes describing the relationship.
  final Attributes? attributes;

  /// Creates a [SpanLink] referencing the given [spanContext] with optional
  /// [attributes].
  const SpanLink({required this.spanContext, this.attributes});

  @override
  bool operator ==(Object other) =>
      other is SpanLink &&
      other.spanContext == spanContext &&
      other.attributes == attributes;

  @override
  int get hashCode => Object.hash(spanContext, attributes);
}

/// A named event that occurred during a [Span]'s lifetime.
///
/// [SpanEvent]s represent meaningful, time-stamped occurrences within a
/// span, such as exceptions, lifecycle milestones, or user annotations.
/// Each event has a [name], [timestamp], and optional [attributes].
final class SpanEvent {
  /// The name of the event.
  final String name;

  /// The time the event occurred.
  final DateTime timestamp;

  /// Optional attributes providing additional context.
  final Attributes? attributes;

  /// Creates a [SpanEvent] with the given [name], [timestamp], and optional
  /// [attributes].
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
