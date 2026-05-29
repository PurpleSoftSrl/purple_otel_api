import '../metrics/meter.dart'
    show
        Meter,
        Counter,
        UpDownCounter,
        DoubleHistogram,
        LongHistogram,
        ObservableDoubleGauge,
        ObservableLongGauge,
        ObservableLongCounter,
        ObservableDoubleCounter,
        ObservableLongUpDownCounter,
        ObservableDoubleUpDownCounter,
        Measurement;
import '../common/attributes.dart' show Attributes;

/// A no-op implementation of [Meter] that returns no-op instruments.
///
/// All instrument creation methods return no-op implementations that
/// discard all data. Use this meter when metrics collection is disabled.
final class NoopMeter implements Meter {
  const NoopMeter();

  @override
  Counter<int> createCounter(String name,
          {String? unit, String? description}) =>
      const _NoopCounter();

  @override
  UpDownCounter<int> createUpDownCounter(String name,
          {String? unit, String? description}) =>
      const _NoopUpDownCounter();

  @override
  DoubleHistogram createDoubleHistogram(String name,
          {String? unit,
          String? description,
          List<double>? explicitBucketBoundaries}) =>
      const _NoopDoubleHistogram();

  @override
  LongHistogram createLongHistogram(String name,
          {String? unit,
          String? description,
          List<double>? explicitBucketBoundaries}) =>
      const _NoopLongHistogram();

  @override
  ObservableDoubleGauge createDoubleObservableGauge(String name,
          {String? unit,
          String? description,
          required List<Measurement<double>> Function() callback}) =>
      const _NoopObservableDoubleGauge();

  @override
  ObservableLongGauge createLongObservableGauge(String name,
          {String? unit,
          String? description,
          required List<Measurement<int>> Function() callback}) =>
      const _NoopObservableLongGauge();

  @override
  ObservableLongCounter createLongObservableCounter(String name,
          {String? unit,
          String? description,
          required List<Measurement<int>> Function() callback}) =>
      const _NoopObservableLongCounter();

  @override
  ObservableDoubleCounter createDoubleObservableCounter(String name,
          {String? unit,
          String? description,
          required List<Measurement<double>> Function() callback}) =>
      const _NoopObservableDoubleCounter();

  @override
  ObservableLongUpDownCounter createLongObservableUpDownCounter(String name,
          {String? unit,
          String? description,
          required List<Measurement<int>> Function() callback}) =>
      const _NoopObservableLongUpDownCounter();

  @override
  ObservableDoubleUpDownCounter createDoubleObservableUpDownCounter(String name,
          {String? unit,
          String? description,
          required List<Measurement<double>> Function() callback}) =>
      const _NoopObservableDoubleUpDownCounter();
}

final class _NoopCounter implements Counter<int> {
  const _NoopCounter();
  @override
  void add(int value, {Attributes? attributes}) {}
}

final class _NoopUpDownCounter implements UpDownCounter<int> {
  const _NoopUpDownCounter();
  @override
  void add(int value, {Attributes? attributes}) {}
}

final class _NoopDoubleHistogram implements DoubleHistogram {
  const _NoopDoubleHistogram();
  @override
  void record(double value, {Attributes? attributes}) {}
}

final class _NoopLongHistogram implements LongHistogram {
  const _NoopLongHistogram();
  @override
  void record(int value, {Attributes? attributes}) {}
}

final class _NoopObservableDoubleGauge implements ObservableDoubleGauge {
  const _NoopObservableDoubleGauge();
  @override
  void observe(double value, {Attributes? attributes}) {}
}

final class _NoopObservableLongGauge implements ObservableLongGauge {
  const _NoopObservableLongGauge();
  @override
  void observe(int value, {Attributes? attributes}) {}
}

final class _NoopObservableLongCounter implements ObservableLongCounter {
  const _NoopObservableLongCounter();
  @override
  void observe(int value, {Attributes? attributes}) {}
}

final class _NoopObservableDoubleCounter implements ObservableDoubleCounter {
  const _NoopObservableDoubleCounter();
  @override
  void observe(double value, {Attributes? attributes}) {}
}

final class _NoopObservableLongUpDownCounter
    implements ObservableLongUpDownCounter {
  const _NoopObservableLongUpDownCounter();
  @override
  void observe(int value, {Attributes? attributes}) {}
}

final class _NoopObservableDoubleUpDownCounter
    implements ObservableDoubleUpDownCounter {
  const _NoopObservableDoubleUpDownCounter();
  @override
  void observe(double value, {Attributes? attributes}) {}
}
