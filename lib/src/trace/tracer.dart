import '../common/attribute_value.dart' show AttributeValue;
import '../common/attributes.dart' show Attributes;
import '../common/identifiers.dart';
import '../context/context.dart' show Context;
import 'span.dart';
import 'span_kind.dart';
import 'span_status.dart';

abstract interface class Tracer {
  Span startSpan(
    String name, {
    SpanKind? kind,
    Context? parentContext,
    Attributes? attributes,
    List<SpanLink>? links,
    DateTime? startTime,
  });
}

abstract interface class Span {
  SpanContext get spanContext;
  bool get isRecording;
  void setStatus(SpanStatus status);
  void setAttribute(String key, AttributeValue value);
  void setAttributes(Attributes attributes);
  void addEvent(String name, {DateTime? timestamp, Attributes? attributes});
  void addLink(SpanContext spanContext, {Attributes? attributes});
  void recordException(Object exception,
      {StackTrace? stackTrace, Attributes? attributes});
  void updateName(String name);
  void end([DateTime? endTime]);
}

abstract interface class SpanProcessor {
  bool get isStartRequired;
  bool get isEndRequired;
  void onStart(Context context, Span span);
  void onEnd(Span span);
  Future<void> forceFlush();
  Future<void> shutdown();
}

enum SamplingDecision { drop, recordOnly, recordAndSample }

final class SamplingResult {
  final SamplingDecision decision;
  final Attributes? attributes;

  const SamplingResult(this.decision, {this.attributes});

  static const drop = SamplingResult(SamplingDecision.drop);
  static const recordOnly = SamplingResult(SamplingDecision.recordOnly);
  static const recordAndSample =
      SamplingResult(SamplingDecision.recordAndSample);
}

abstract interface class Sampler {
  SamplingResult shouldSample({
    required Context parentContext,
    required TraceId traceId,
    required String name,
    required SpanKind spanKind,
    required Attributes attributes,
    required List<SpanLink> links,
  });

  String get description;
}

abstract interface class IdGenerator {
  TraceId generateTraceId();
  SpanId generateSpanId();
}

final class SpanLimits {
  final int maxAttributes;
  final int maxEvents;
  final int maxLinks;
  final int maxAttributesPerEvent;
  final int maxAttributesPerLink;
  final int maxAttributeValueLength;

  const SpanLimits({
    this.maxAttributes = 128,
    this.maxEvents = 128,
    this.maxLinks = 128,
    this.maxAttributesPerEvent = 128,
    this.maxAttributesPerLink = 128,
    this.maxAttributeValueLength = 2048,
  });
}
