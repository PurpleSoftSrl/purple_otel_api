import 'attribute_value.dart';

final class Attributes {
  final Map<String, AttributeValue> _data;

  const Attributes._(this._data);

  const Attributes.empty() : _data = const {};

  Attributes.of(Map<String, AttributeValue> data)
      : _data = Map<String, AttributeValue>.unmodifiable(data);

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

  Map<String, AttributeValue> get entries =>
      Map<String, AttributeValue>.unmodifiable(_data);

  AttributeValue? get(String key) => _data[key];

  int get length => _data.length;

  bool get isEmpty => _data.isEmpty;

  bool get isNotEmpty => _data.isNotEmpty;

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
