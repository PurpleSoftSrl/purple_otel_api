import '../resource/resource.dart';

/// Detects [Resource] information from the runtime environment.
///
/// [ResourceDetector] implementations inspect the environment (e.g.,
/// environment variables, host metadata, process information) and return
/// a [Resource] with the detected [Attributes]. Multiple detectors may be
/// chained, with results merged via [Resource.merge].
abstract interface class ResourceDetector {
  /// Returns the detected [Resource].
  Resource detect();
}
