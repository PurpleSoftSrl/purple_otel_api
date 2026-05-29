import '../export/signal_provider.dart' show MeterProvider;
import '../metrics/meter.dart' show Meter;
import 'noop_meter.dart' show NoopMeter;

final class NoopMeterProvider implements MeterProvider {
  const NoopMeterProvider();

  @override
  Meter get(String name, {String? version, String? schemaUrl}) =>
      const NoopMeter();

  @override
  Future<void> forceFlush() async {}

  @override
  Future<void> shutdown() async {}
}
