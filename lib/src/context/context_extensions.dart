import '../context/context.dart' show Context, ContextKey;
import '../baggage/baggage.dart' show Baggage;
import '../trace/tracer.dart' show Span;

final spanContextKey = ContextKey<Span>('span');
final baggageContextKey = ContextKey<Baggage>('baggage');

extension ContextTraceExtension on Context {
  Span? get span => get(spanContextKey);
}

extension ContextBaggageExtension on Context {
  Baggage? get baggage => get(baggageContextKey);
}
