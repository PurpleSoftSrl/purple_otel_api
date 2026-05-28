import 'attributes.dart';

final class InstrumentationScope {
  final String name;
  final String? version;
  final String? schemaUrl;
  final Attributes attributes;

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
