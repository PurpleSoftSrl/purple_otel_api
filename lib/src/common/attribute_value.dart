import 'dart:typed_data';

sealed class AttributeValue {
  const AttributeValue();

  const factory AttributeValue.string(String value) = _StringAttr;
  const factory AttributeValue.int(int value) = _IntAttr;
  const factory AttributeValue.double(double value) = _DoubleAttr;
  const factory AttributeValue.bool(bool value) = _BoolAttr;
  const factory AttributeValue.list(List<AttributeValue> values) = _ListAttr;
  const factory AttributeValue.bytes(Uint8List value) = _BytesAttr;

  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  });
}

final class _StringAttr extends AttributeValue {
  final String value;
  const _StringAttr(this.value);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      string(value);

  @override
  bool operator ==(Object other) =>
      other is _StringAttr && other.value == value;
  @override
  int get hashCode => Object.hash('StringAttr', value);
  @override
  String toString() => value;
}

final class _IntAttr extends AttributeValue {
  final int value;
  const _IntAttr(this.value);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      int(value);

  @override
  bool operator ==(Object other) => other is _IntAttr && other.value == value;
  @override
  int get hashCode => Object.hash('IntAttr', value);
  @override
  String toString() => '$value';
}

final class _DoubleAttr extends AttributeValue {
  final double value;
  const _DoubleAttr(this.value);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      double(value);

  @override
  bool operator ==(Object other) =>
      other is _DoubleAttr && other.value == value;
  @override
  int get hashCode => Object.hash('DoubleAttr', value);
  @override
  String toString() => '$value';
}

final class _BoolAttr extends AttributeValue {
  final bool value;
  const _BoolAttr(this.value);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      bool(value);

  @override
  bool operator ==(Object other) => other is _BoolAttr && other.value == value;
  @override
  int get hashCode => Object.hash('BoolAttr', value);
  @override
  String toString() => '$value';
}

final class _ListAttr extends AttributeValue {
  final List<AttributeValue> values;
  const _ListAttr(this.values);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      list(values);

  @override
  bool operator ==(Object other) =>
      other is _ListAttr && _listEquals(other.values, values);
  @override
  int get hashCode => Object.hash('ListAttr', Object.hashAll(values));
  @override
  String toString() => '[${values.join(', ')}]';
}

final class _BytesAttr extends AttributeValue {
  final Uint8List value;
  const _BytesAttr(this.value);

  @override
  T map<T>({
    required T Function(String value) string,
    required T Function(int value) int,
    required T Function(double value) double,
    required T Function(bool value) bool,
    required T Function(List<AttributeValue> values) list,
    required T Function(Uint8List value) bytes,
  }) =>
      bytes(value);

  @override
  bool operator ==(Object other) =>
      other is _BytesAttr && _bytesEquals(other.value, value);
  @override
  int get hashCode => Object.hash('BytesAttr', Object.hashAll(value));
  @override
  String toString() => '<bytes ${value.length}B>';
}

bool _listEquals(List<AttributeValue> a, List<AttributeValue> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _bytesEquals(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
