/// A generic metric data point produced by a [Meter] instrument.
///
/// [Metric] is a marker interface for typed metric data exported by
/// [MetricReader]s and [MetricExporter]s.
abstract interface class Metric {}

/// A hint that a [Metric] is being exported.
///
/// No-op class used as a signal identifier in export pipelines.
final class MetricExporterHint {}
