import '../common/attributes.dart' show Attributes;

abstract interface class Meter {
  Counter<int> createCounter(String name, {String? unit, String? description});
  UpDownCounter<int> createUpDownCounter(String name,
      {String? unit, String? description});
  DoubleHistogram createDoubleHistogram(String name,
      {String? unit,
      String? description,
      List<double>? explicitBucketBoundaries});
  LongHistogram createLongHistogram(String name,
      {String? unit,
      String? description,
      List<double>? explicitBucketBoundaries});

  ObservableDoubleGauge createDoubleObservableGauge(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});
  ObservableLongGauge createLongObservableGauge(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});
  ObservableLongCounter createLongObservableCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});
  ObservableDoubleCounter createDoubleObservableCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});
  ObservableLongUpDownCounter createLongObservableUpDownCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<int>> Function() callback});
  ObservableDoubleUpDownCounter createDoubleObservableUpDownCounter(String name,
      {String? unit,
      String? description,
      required List<Measurement<double>> Function() callback});
}

abstract interface class Counter<T extends num> {
  void add(T value, {Attributes? attributes});
}

abstract interface class UpDownCounter<T extends num> {
  void add(T value, {Attributes? attributes});
}

abstract interface class DoubleHistogram {
  void record(double value, {Attributes? attributes});
}

abstract interface class LongHistogram {
  void record(int value, {Attributes? attributes});
}

final class Measurement<T extends num> {
  final T value;
  final Attributes attributes;
  const Measurement(this.value, {this.attributes = const Attributes.empty()});
}

abstract interface class ObservableDoubleGauge {
  void observe(double value, {Attributes? attributes});
}

abstract interface class ObservableLongGauge {
  void observe(int value, {Attributes? attributes});
}

abstract interface class ObservableLongCounter {
  void observe(int value, {Attributes? attributes});
}

abstract interface class ObservableDoubleCounter {
  void observe(double value, {Attributes? attributes});
}

abstract interface class ObservableLongUpDownCounter {
  void observe(int value, {Attributes? attributes});
}

abstract interface class ObservableDoubleUpDownCounter {
  void observe(double value, {Attributes? attributes});
}

abstract interface class MetricReader {
  Future<void> forceFlush();
  Future<void> shutdown();
}

final class View {
  final String? name;
  final String? instrumentName;
  final String? aggregation;
  final List<String>? attributeKeys;

  const View(
      {this.name, this.instrumentName, this.aggregation, this.attributeKeys});
}

final class MetricCardinalityLimits {
  final int maxAttributeCombinations;
  final int maxAttributeKeys;
  final int maxAttributeValueLength;

  const MetricCardinalityLimits({
    this.maxAttributeCombinations = 2000,
    this.maxAttributeKeys = 128,
    this.maxAttributeValueLength = 1024,
  });
}
