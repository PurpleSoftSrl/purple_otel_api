import 'attributes.dart';

/// Identifies the instrumentation that produced telemetry data.
///
/// An [InstrumentationScope] ties a [name], optional [version], optional
/// [schemaUrl], and optional [attributes] to a logical instrumentation
/// library. It is attached to signals emitted by [Tracer]s, [Logger]s,
/// and [Meter]s to identify the producing library.
final class InstrumentationScope {
  /// The name of the instrumentation scope.
  final String name;

  /// The version of the instrumentation library, if available.
  final String? version;

  /// The URL of the OpenTelemetry schema, if applicable.
  final String? schemaUrl;

  /// Optional attributes associated with this scope.
  final Attributes attributes;

  /// Creates an [InstrumentationScope] with the given [name] and optional
  /// [version], [schemaUrl], and [attributes].
  const InstrumentationScope({
    required this.name,
    this.version,
    this.schemaUrl,
    this.attributes = const Attributes.empty(),
  });

  @override
  bool operator ==(Object other) =>
      other is InstrumentationScope &&
      other.name == name &&
      other.version == version &&
      other.schemaUrl == schemaUrl;

  @override
  int get hashCode => Object.hash(name, version, schemaUrl);

  @override
  String toString() => 'InstrumentationScope($name, v$version)';
}
