import '../context/context.dart' show Context, ContextKey;
import '../baggage/baggage.dart' show Baggage;
import '../trace/tracer.dart' show Span;

/// The [ContextKey] for retrieving the active [Span] from a [Context].
final spanContextKey = ContextKey<Span>('span');

/// The [ContextKey] for retrieving the active [Baggage] from a [Context].
final baggageContextKey = ContextKey<Baggage>('baggage');

/// Convenience extension to retrieve the active [Span] from a [Context].
extension ContextTraceExtension on Context {
  /// The active [Span] stored in this context, or `null` if none.
  Span? get span => get(spanContextKey);
}

/// Convenience extension to retrieve the active [Baggage] from a [Context].
extension ContextBaggageExtension on Context {
  /// The active [Baggage] stored in this context, or `null` if none.
  Baggage? get baggage => get(baggageContextKey);
}
