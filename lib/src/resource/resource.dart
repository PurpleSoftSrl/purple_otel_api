import '../common/attributes.dart';

/// Describes the entity producing telemetry data.
///
/// A [Resource] carries [Attributes] that identify the source of telemetry,
/// such as service name, host, process, and other metadata. It is attached
/// to all signals produced by a provider.
///
/// Use [Resource.empty] for a resource with no attributes, or [merge] to
/// combine resources. Resources detected via [ResourceDetector] are
/// typically merged before being assigned to a provider.
final class Resource {
  /// The attributes describing this resource.
  final Attributes attributes;

  /// Creates a [Resource] with the given [attributes].
  const Resource(this.attributes);

  /// An empty [Resource] with no attributes.
  static const Resource empty = Resource(const Attributes.empty());

  /// Returns a new [Resource] combining the [attributes] of this and
  /// [other].
  ///
  /// If [other] has no attributes, returns this instance directly.
  /// Entries from [other] override entries with the same key from this
  /// instance.
  Resource merge(Resource other) {
    if (other.attributes.isEmpty) return this;
    return Resource(attributes.merge(other.attributes));
  }

  @override
  bool operator ==(Object other) =>
      other is Resource && other.attributes == attributes;

  @override
  int get hashCode => attributes.hashCode;

  @override
  String toString() => 'Resource($attributes)';
}
