import 'attribute_value.dart';

/// An immutable map of string keys to [AttributeValue] values.
///
/// [Attributes] provides a structured container for metadata attached to
/// spans, log records, and metrics. Construct via:
/// - [Attributes.empty()]: an empty instance
/// - [Attributes.of()]: from an existing [Map] of [AttributeValue]s
/// - [Attributes.fromMap()]: from a `Map<String, Object?>` with automatic
///   type conversion
///
/// Use [get] to retrieve values, [merge] to combine attributes, and
/// [length], [isEmpty], [isNotEmpty] to inspect the collection.
final class Attributes {
  final Map<String, AttributeValue> _data;

  const Attributes._(this._data);

  /// Creates an empty [Attributes] instance.
  const Attributes.empty() : _data = const {};

  /// Creates an [Attributes] from the given [data] map of [AttributeValue]s.
  ///
  /// The map is made unmodifiable.
  Attributes.of(Map<String, AttributeValue> data)
      : _data = Map<String, AttributeValue>.unmodifiable(data);

  /// Creates an [Attributes] from a [map] with automatic type conversion.
  ///
  /// Each value in [map] is converted to an [AttributeValue] using the
  /// following rules: [String], [int], [double], [bool] are wrapped directly.
  /// [List] elements are recursively converted. Other types are converted
  /// via [Object.toString]. `null` values are skipped.
  Attributes.fromMap(Map<String, Object?> map) : _data = _convertMap(map);

  static Map<String, AttributeValue> _convertMap(Map<String, Object?> map) {
    final data = <String, AttributeValue>{};
    for (final entry in map.entries) {
      final value = entry.value;
      if (value != null) {
        data[entry.key] = _convert(value);
      }
    }
    return Map<String, AttributeValue>.unmodifiable(data);
  }

  static AttributeValue _convert(Object value) {
    if (value is String) return AttributeValue.string(value);
    if (value is int) return AttributeValue.int(value);
    if (value is double) return AttributeValue.double(value);
    if (value is bool) return AttributeValue.bool(value);
    if (value is List)
      return AttributeValue.list(
          value.map((e) => _convert(e as Object)).toList());
    return AttributeValue.string(value.toString());
  }

  /// Returns an unmodifiable copy of the underlying map entries.
  Map<String, AttributeValue> get entries =>
      Map<String, AttributeValue>.unmodifiable(_data);

  /// Returns the [AttributeValue] for [key], or `null` if not present.
  AttributeValue? get(String key) => _data[key];

  /// The number of entries in this container.
  int get length => _data.length;

  /// Whether this container has no entries.
  bool get isEmpty => _data.isEmpty;

  /// Whether this container has at least one entry.
  bool get isNotEmpty => _data.isNotEmpty;

  /// Returns a new [Attributes] combining this and [other].
  ///
  /// Entries in [other] override entries with the same key from this
  /// instance. If [other] is empty, this instance is returned directly.
  Attributes merge(Attributes other) {
    if (other.isEmpty) return this;
    final merged = <String, AttributeValue>{..._data, ...other._data};
    return Attributes._(Map<String, AttributeValue>.unmodifiable(merged));
  }

  @override
  bool operator ==(Object other) =>
      other is Attributes && _mapEquals(other._data, _data);

  @override
  int get hashCode => Object.hashAll(_data.entries);

  @override
  String toString() => _data.toString();
}

bool _mapEquals(Map<String, AttributeValue> a, Map<String, AttributeValue> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
