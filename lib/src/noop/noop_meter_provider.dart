import '../export/signal_provider.dart' show MeterProvider;
import '../metrics/meter.dart' show Meter;
import 'noop_meter.dart' show NoopMeter;

/// A no-op implementation of [MeterProvider] that returns [NoopMeter].
///
/// All methods are no-ops. Use this provider when metrics collection is
/// disabled or when no real meter is available.
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
