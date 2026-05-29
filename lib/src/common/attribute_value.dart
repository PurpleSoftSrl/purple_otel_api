import 'dart:typed_data';

/// A typed value that can be stored in an [Attributes] map.
///
/// [AttributeValue] is a sealed class with six subtypes representing the
/// supported OpenTelemetry attribute types:
/// - [AttributeValue.string]: wraps a [String]
/// - [AttributeValue.int]: wraps an [int]
/// - [AttributeValue.double]: wraps a [double]
/// - [AttributeValue.bool]: wraps a [bool]
/// - [AttributeValue.list]: wraps a homogeneous [List] of [AttributeValue]s
/// - [AttributeValue.bytes]: wraps a [Uint8List] for binary data
///
/// Use the [map] method to pattern-match on the concrete type and extract
/// the value in a type-safe manner.
sealed class AttributeValue {
  const AttributeValue();

  /// Wraps a [String] [value].
  const factory AttributeValue.string(String value) = _StringAttr;

  /// Wraps an [int] [value].
  const factory AttributeValue.int(int value) = _IntAttr;

  /// Wraps a [double] [value].
  const factory AttributeValue.double(double value) = _DoubleAttr;

  /// Wraps a [bool] [value].
  const factory AttributeValue.bool(bool value) = _BoolAttr;

  /// Wraps a [List] of [AttributeValue] [values].
  const factory AttributeValue.list(List<AttributeValue> values) = _ListAttr;

  /// Wraps a [Uint8List] [value] for binary data.
  const factory AttributeValue.bytes(Uint8List value) = _BytesAttr;

  /// Pattern-matches on the concrete subtype and returns the result of the
  /// corresponding callback.
  ///
  /// Each callback receives the unwrapped value of its type. The [string],
  /// [int], [double], [bool], [list], and [bytes] callbacks must all be
  /// provided.
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
