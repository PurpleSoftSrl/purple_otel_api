import '../common/attribute_value.dart' show AttributeValue;
import '../common/attributes.dart' show Attributes;
import '../common/identifiers.dart';
import '../context/context.dart' show Context;
import 'span.dart';
import 'span_kind.dart';
import 'span_status.dart';

/// Creates and manages [Span] instances representing a single operation.
///
/// A [Tracer] is obtained from a [TracerProvider] and is used to create
/// [Span]s that trace the execution of a request or operation. The tracer
/// encapsulates the configuration for generating spans, including the
/// [Sampler], [SpanProcessor], and [IdGenerator].
abstract interface class Tracer {
  /// Starts a new [Span] with the given [name].
  ///
  /// The optional [kind] specifies the [SpanKind] describing the
  /// relationship between the span, its parents, and its children.
  /// The optional [parentContext] provides an explicit parent [Context];
  /// if omitted, the current context from the [ContextStorage] is used.
  /// The optional [attributes] and [links] provide initial metadata.
  /// The optional [startTime] sets the span's start timestamp; if omitted
  /// the current time is used.
  Span startSpan(
    String name, {
    SpanKind? kind,
    Context? parentContext,
    Attributes? attributes,
    List<SpanLink>? links,
    DateTime? startTime,
  });
}

/// Represents a single operation within a trace, created by a [Tracer].
///
/// A [Span] carries the [SpanContext] identifying it and accumulates
/// attributes, events, links, and status information during its lifetime.
/// Call [end] to complete the span and trigger export via registered
/// [SpanProcessor]s.
abstract interface class Span {
  /// The [SpanContext] that uniquely identifies this span.
  SpanContext get spanContext;

  /// Whether this span is recording events and attributes.
  ///
  /// Returns `false` for non-recording spans (e.g., when the span was
  /// dropped by the [Sampler]).
  bool get isRecording;

  /// Sets the [SpanStatus] for this span.
  ///
  /// The status describes the outcome of the operation (e.g., [SpanStatus.ok]
  /// or [SpanStatus.error]).
  void setStatus(SpanStatus status);

  /// Sets a single [AttributeValue] on this span identified by [key].
  void setAttribute(String key, AttributeValue value);

  /// Merges the given [Attributes] into this span's attributes.
  void setAttributes(Attributes attributes);

  /// Adds a named [SpanEvent] with an optional [timestamp] and
  /// [attributes] to the span's timeline.
  void addEvent(String name, {DateTime? timestamp, Attributes? attributes});

  /// Adds a [SpanLink] to the given [spanContext] with optional [attributes].
  void addLink(SpanContext spanContext, {Attributes? attributes});

  /// Records an [exception] that occurred during the span's operation.
  ///
  /// The optional [stackTrace] and [attributes] provide additional context
  /// for the error.
  void recordException(Object exception,
      {StackTrace? stackTrace, Attributes? attributes});

  /// Updates the display name of this span.
  void updateName(String name);

  /// Ends this span with an optional [endTime].
  ///
  /// After calling [end], the span is considered complete and is passed to
  /// the registered [SpanProcessor.onEnd] for export.
  void end([DateTime? endTime]);
}

/// Processes [Span] lifecycle events for export.
///
/// [SpanProcessor] hooks into the span lifecycle. If [isStartRequired] is
/// `true`, [onStart] is called when a span is created. If [isEndRequired]
/// is `true`, [onEnd] is called when a span ends. Implementations typically
/// batch spans and forward them to a [SpanExporter].
///
/// Call [forceFlush] to flush any pending spans synchronously within a
/// configurable timeout, and [shutdown] to permanently stop the processor.
abstract interface class SpanProcessor {
  /// Whether this processor requires [onStart] to be called.
  bool get isStartRequired;

  /// Whether this processor requires [onEnd] to be called.
  bool get isEndRequired;

  /// Called when a [span] is started with the given [context].
  void onStart(Context context, Span span);

  /// Called when a [span] has ended.
  void onEnd(Span span);

  /// Flushes any pending spans, returning a [Future] that completes when
  /// the flush is done.
  Future<void> forceFlush();

  /// Shuts down the processor, releasing resources and flushing pending
  /// spans before completing.
  Future<void> shutdown();
}

/// The decision made by a [Sampler] for a given span.
enum SamplingDecision {
  /// The span is dropped and no further processing occurs.
  drop,

  /// The span is recorded (attributes, events, links are captured) but
  /// not sampled for export.
  recordOnly,

  /// The span is both recorded and sampled for export.
  recordAndSample,
}

/// The result of a [Sampler.shouldSample] call.
///
/// Contains the [decision] and optional [attributes] that should be appended
/// to the span if sampled.
final class SamplingResult {
  /// The [SamplingDecision] for this span.
  final SamplingDecision decision;

  /// Optional attributes to append to the span.
  final Attributes? attributes;

  /// Creates a [SamplingResult] with the given [decision] and optional
  /// [attributes].
  const SamplingResult(this.decision, {this.attributes});

  /// A convenience constant for [SamplingDecision.drop].
  static const drop = SamplingResult(SamplingDecision.drop);

  /// A convenience constant for [SamplingDecision.recordOnly].
  static const recordOnly = SamplingResult(SamplingDecision.recordOnly);

  /// A convenience constant for [SamplingDecision.recordAndSample].
  static const recordAndSample =
      SamplingResult(SamplingDecision.recordAndSample);
}

/// Decides whether a [Span] should be sampled based on the given parameters.
///
/// Implementations may consider the [parentContext], [traceId], [name],
/// [spanKind], [attributes], and [links] when making the sampling decision.
abstract interface class Sampler {
  /// Returns a [SamplingResult] indicating whether the span described by
  /// the given parameters should be sampled.
  ///
  /// The [parentContext] is the parent span's [Context], [traceId] is the
  /// [TraceId] of the new span, [name] is the span name, [spanKind] is the
  /// [SpanKind], [attributes] are the initial attributes, and [links] are
  /// the [SpanLink]s.
  SamplingResult shouldSample({
    required Context parentContext,
    required TraceId traceId,
    required String name,
    required SpanKind spanKind,
    required Attributes attributes,
    required List<SpanLink> links,
  });

  /// A human-readable description of this sampler for diagnostic purposes.
  String get description;
}

/// Generates [TraceId] and [SpanId] identifiers for new spans.
abstract interface class IdGenerator {
  /// Generates a new unique [TraceId].
  TraceId generateTraceId();

  /// Generates a new unique [SpanId].
  SpanId generateSpanId();
}

/// Limits applied to span data to bound memory usage.
///
/// Configurable limits govern the maximum number of attributes, events,
/// links, and attribute value lengths for each span.
final class SpanLimits {
  /// Maximum number of attributes per span. Defaults to 128.
  final int maxAttributes;

  /// Maximum number of events per span. Defaults to 128.
  final int maxEvents;

  /// Maximum number of links per span. Defaults to 128.
  final int maxLinks;

  /// Maximum number of attributes per event. Defaults to 128.
  final int maxAttributesPerEvent;

  /// Maximum number of attributes per link. Defaults to 128.
  final int maxAttributesPerLink;

  /// Maximum length of an attribute value string. Defaults to 2048.
  final int maxAttributeValueLength;

  /// Creates a [SpanLimits] with the given configuration.
  const SpanLimits({
    this.maxAttributes = 128,
    this.maxEvents = 128,
    this.maxLinks = 128,
    this.maxAttributesPerEvent = 128,
    this.maxAttributesPerLink = 128,
    this.maxAttributeValueLength = 2048,
  });
}
