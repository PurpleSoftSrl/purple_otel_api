import '../common/attribute_value.dart' show AttributeValue;
import '../common/attributes.dart' show Attributes;
import '../common/identifiers.dart' show TraceId, SpanId, TraceFlags;
import '../context/context.dart' show Context;
import '../trace/tracer.dart' show Tracer, Span;
import '../trace/span.dart' show SpanLink, SpanContext;
import '../trace/span_kind.dart' show SpanKind;
import '../trace/span_status.dart' show SpanStatus;

/// A no-op implementation of [Tracer] that creates [NoopSpan]s.
///
/// All methods are no-ops. Use this tracer when tracing is disabled.
final class NoopTracer implements Tracer {
  const NoopTracer();

  @override
  Span startSpan(
    String name, {
    SpanKind? kind,
    Context? parentContext,
    Attributes? attributes,
    List<SpanLink>? links,
    DateTime? startTime,
  }) =>
      const NoopSpan();
}

/// A no-op implementation of [Span] that discards all data.
///
/// [isRecording] always returns `false`. All mutation methods are no-ops.
/// The [spanContext] returns an invalid context with an all-zero [TraceId]
/// and [SpanId].
final class NoopSpan implements Span {
  const NoopSpan();

  @override
  SpanContext get spanContext => SpanContext(
        traceId: TraceId.invalid(),
        spanId: SpanId.invalid(),
        traceFlags: TraceFlags.none,
      );

  @override
  bool get isRecording => false;

  @override
  void setStatus(SpanStatus status) {}

  @override
  void setAttribute(String key, AttributeValue value) {}

  @override
  void setAttributes(Attributes attributes) {}

  @override
  void addEvent(String name, {DateTime? timestamp, Attributes? attributes}) {}

  @override
  void addLink(SpanContext spanContext, {Attributes? attributes}) {}

  @override
  void recordException(Object exception,
      {StackTrace? stackTrace, Attributes? attributes}) {}

  @override
  void updateName(String name) {}

  @override
  void end([DateTime? endTime]) {}
}
