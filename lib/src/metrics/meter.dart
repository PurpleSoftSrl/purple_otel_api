import '../common/attributes.dart' show Attributes;

/// Creates and manages metric instruments.
///
/// A [Meter] is obtained from a [MeterProvider] and is used to create
/// synchronous and asynchronous instruments: [Counter], [UpDownCounter],
/// [DoubleHistogram], [LongHistogram], and observable gauges/counters.
/// Each instrument name must be unique within the meter.
abstract interface class Meter {
  /// Creates a [Counter] that records non-negative integer increments.
  ///
  /// The optional [unit] describes the measurement unit, and [description]
  /// provides a human-readable explanation of the counter's purpose.
  Counter<int> createCounter(String name, {String? unit, String? description});

  /// Creates an [UpDownCounter] that records integer increments and
  /// decrements (may go negative).
  ///
  /// The optional [unit] describes the measurement unit, and [description]
  /// provides a human-readable explanation.
  UpDownCounter<int> createUpDownCounter(String name,
      {String? unit, String? description});

  /// Creates a [DoubleHistogram] that records floating-point values and
  /// computes statistical distributions.
  ///
  /// The optional [unit] describes the measurement unit, [description]
  /// provides a human-readable explanation, and [explicitBucketBoundaries]
  /// defines custom histogram bucket boundaries.
  DoubleHistogram createDoubleHistogram(String name,
      {String? unit,
      String? description,
      List<double>? explicitBucketBoundaries});

  /// Creates a [LongHistogram] that records integer values and computes
  /// statistical distributions.
  ///
  /// The optional [unit] describes the measurement unit, [description]
  /// provides a human-readable explanation, and [explicitBucketBoundaries]
  /// defines custom histogram bucket boundaries.
  LongHistogram createLongHistogram(String name,
      {String? unit,
      String? description,
      List<double>? explicitBucketBoundaries});

  /// Creates an [ObservableDoubleGauge] that reports floating-point gauge
  /// values asynchronously via the given [callback].
  ///
  /// The [callback] is invoked on collection and must return a list of
  /// [Measurement]s.
  ObservableDoubleGauge createDoubleObservableGauge(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});

  /// Creates an [ObservableLongGauge] that reports integer gauge values
  /// asynchronously via the given [callback].
  ObservableLongGauge createLongObservableGauge(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});

  /// Creates an [ObservableLongCounter] that reports integer counter values
  /// asynchronously via the given [callback].
  ObservableLongCounter createLongObservableCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});

  /// Creates an [ObservableDoubleCounter] that reports floating-point
  /// counter values asynchronously via the given [callback].
  ObservableDoubleCounter createDoubleObservableCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});

  /// Creates an [ObservableLongUpDownCounter] that reports integer up-down
  /// counter values asynchronously via the given [callback].
  ObservableLongUpDownCounter createLongObservableUpDownCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});

  /// Creates an [ObservableDoubleUpDownCounter] that reports floating-point
  /// up-down counter values asynchronously via the given [callback].
  ObservableDoubleUpDownCounter createDoubleObservableUpDownCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});
}

/// A synchronous instrument that records non-negative increments.
///
/// [Counter] supports typed numeric values via [T]. The SDK typically uses
/// `int` for [Counter<int>].
abstract interface class Counter<T extends num> {
  /// Increments the counter by [value], optionally scoped to the given
  /// [attributes].
  void add(T value, {Attributes? attributes});
}

/// A synchronous instrument that records increments and decrements.
///
/// [UpDownCounter] supports typed numeric values via [T] and may record
/// negative values. The SDK typically uses `int` for [UpDownCounter<int>].
abstract interface class UpDownCounter<T extends num> {
  /// Adjusts the counter by [value] (positive or negative), optionally
  /// scoped to the given [attributes].
  void add(T value, {Attributes? attributes});
}

/// A synchronous histogram instrument that records `double` values.
///
/// [DoubleHistogram] aggregates recorded values into configurable
/// [explicitBucketBoundaries] for statistical distribution analysis.
abstract interface class DoubleHistogram {
  /// Records a floating-point [value] to the histogram, optionally scoped
  /// to the given [attributes].
  void record(double value, {Attributes? attributes});
}

/// A synchronous histogram instrument that records `int` values.
///
/// [LongHistogram] aggregates recorded integer values into configurable
/// [explicitBucketBoundaries] for statistical distribution analysis.
abstract interface class LongHistogram {
  /// Records an integer [value] to the histogram, optionally scoped to the
  /// given [attributes].
  void record(int value, {Attributes? attributes});
}

/// A single measurement reported by an observable instrument's callback.
///
/// Each [Measurement] carries a [value] and optional [attributes] that
/// scope the measurement.
final class Measurement<T extends num> {
  /// The measured value.
  final T value;

  /// Optional attributes scoping this measurement.
  final Attributes attributes;

  /// Creates a [Measurement] with the given [value] and optional [attributes].
  const Measurement(this.value, {this.attributes = const Attributes.empty()});
}

/// An asynchronous gauge instrument that reports `double` values.
///
/// Values are produced by the callback passed to
/// [Meter.createDoubleObservableGauge].
abstract interface class ObservableDoubleGauge {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(double value, {Attributes? attributes});
}

/// An asynchronous gauge instrument that reports `int` values.
///
/// Values are produced by the callback passed to
/// [Meter.createLongObservableGauge].
abstract interface class ObservableLongGauge {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(int value, {Attributes? attributes});
}

/// An asynchronous counter instrument that reports `int` values.
///
/// Values are produced by the callback passed to
/// [Meter.createLongObservableCounter]. The counter is monotonic (values
/// only increase over time).
abstract interface class ObservableLongCounter {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(int value, {Attributes? attributes});
}

/// An asynchronous counter instrument that reports `double` values.
///
/// Values are produced by the callback passed to
/// [Meter.createDoubleObservableCounter]. The counter is monotonic (values
/// only increase over time).
abstract interface class ObservableDoubleCounter {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(double value, {Attributes? attributes});
}

/// An asynchronous up-down counter instrument that reports `int` values.
///
/// Values are produced by the callback passed to
/// [Meter.createLongObservableUpDownCounter]. Values may increase or
/// decrease.
abstract interface class ObservableLongUpDownCounter {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(int value, {Attributes? attributes});
}

/// An asynchronous up-down counter instrument that reports `double` values.
///
/// Values are produced by the callback passed to
/// [Meter.createDoubleObservableUpDownCounter]. Values may increase or
/// decrease.
abstract interface class ObservableDoubleUpDownCounter {
  /// Reports the given [value], optionally scoped to the given [attributes].
  void observe(double value, {Attributes? attributes});
}

/// Reads metrics from the SDK and exports them.
///
/// A [MetricReader] collects metrics from [Meter] instruments and passes
/// them to a [MetricExporter]. Call [forceFlush] to flush pending data and
/// [shutdown] to permanently stop the reader.
abstract interface class MetricReader {
  /// Flushes any pending metrics, returning a [Future] that completes when
  /// the flush is done.
  Future<void> forceFlush();

  /// Shuts down the reader, releasing resources and flushing pending
  /// metrics before completing.
  Future<void> shutdown();
}

/// Configures aggregation and attribute selection for a metric instrument.
///
/// A [View] is used by a [MetricReader] to customize how metric data is
/// aggregated. It can filter instruments by [name] and [instrumentName],
/// override the [aggregation] type, and limit which [attributeKeys] are
/// included.
final class View {
  /// The new name for the metric stream, or `null` to keep the original.
  final String? name;

  /// The instrument name pattern to match against, or `null` to match all.
  final String? instrumentName;

  /// The aggregation type override, or `null` to use the default.
  final String? aggregation;

  /// The allowed attribute keys, or `null` to include all.
  final List<String>? attributeKeys;

  /// Creates a [View] with the given configuration.
  const View(
      {this.name, this.instrumentName, this.aggregation, this.attributeKeys});
}

/// Limits applied to metric data to bound memory usage.
///
/// Configurable limits govern the maximum number of attribute combinations,
/// attribute keys, and attribute value lengths for metric streams.
final class MetricCardinalityLimits {
  /// Maximum number of unique attribute combinations. Defaults to 2000.
  final int maxAttributeCombinations;

  /// Maximum number of distinct attribute keys. Defaults to 128.
  final int maxAttributeKeys;

  /// Maximum length of an attribute value string. Defaults to 1024.
  final int maxAttributeValueLength;

  /// Creates a [MetricCardinalityLimits] with the given configuration.
  const MetricCardinalityLimits({
    this.maxAttributeCombinations = 2000,
    this.maxAttributeKeys = 128,
    this.maxAttributeValueLength = 1024,
  });
}
