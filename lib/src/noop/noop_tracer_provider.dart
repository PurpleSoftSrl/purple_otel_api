import '../export/signal_provider.dart' show TracerProvider;
import '../trace/tracer.dart' show Tracer;
import 'noop_tracer.dart' show NoopTracer;

final class NoopTracerProvider implements TracerProvider {
  const NoopTracerProvider();

  @override
  Tracer get(String name, {String? version, String? schemaUrl}) => const NoopTracer();

  @override
  Future<void> forceFlush() async {}

  @override
  Future<void> shutdown() async {}
}
