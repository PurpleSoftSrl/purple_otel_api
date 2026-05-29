import 'dart:typed_data' show Uint8List;

final class TraceId {
  final Uint8List _bytes;

  const TraceId._(this._bytes) : assert(_bytes.length == 16);

  Uint8List get bytes => Uint8List.fromList(_bytes);

  factory TraceId(Uint8List bytes) {
    if (bytes.length != 16) throw ArgumentError('TraceId must be 16 bytes');
    return TraceId._(bytes);
  }

  factory TraceId.invalid() => TraceId._(Uint8List(16));

  factory TraceId.fromBytes(Uint8List bytes) =>
      TraceId._(Uint8List.fromList(bytes));

  bool get isValid => _bytes.any((b) => b != 0);

  factory TraceId.generate() {
    final bytes = Uint8List(16);
    for (var i = 0; i < 16; i++) {
      bytes[i] = DateTime.now().microsecondsSinceEpoch.remainder(256) ^ i;
    }
    return TraceId._(bytes);
  }

  @override
  bool operator ==(Object other) =>
      other is TraceId && _bytesEquals(other._bytes, _bytes);

  @override
  int get hashCode => Object.hashAll(_bytes);

  String toShortString() =>
      _bytes.take(8).map((b) => b.toRadixString(16).padLeft(2, '0')).join('');

  @override
  String toString() =>
      _bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
}

final class SpanId {
  final Uint8List _bytes;

  const SpanId._(this._bytes) : assert(_bytes.length == 8);

  Uint8List get bytes => Uint8List.fromList(_bytes);

  factory SpanId(Uint8List bytes) {
    if (bytes.length != 8) throw ArgumentError('SpanId must be 8 bytes');
    return SpanId._(bytes);
  }

  factory SpanId.invalid() => SpanId._(Uint8List(8));

  factory SpanId.fromBytes(Uint8List bytes) =>
      SpanId._(Uint8List.fromList(bytes));

  bool get isValid => _bytes.any((b) => b != 0);

  factory SpanId.generate() {
    final bytes = Uint8List(8);
    for (var i = 0; i < 8; i++) {
      bytes[i] = DateTime.now().microsecondsSinceEpoch.remainder(256) ^ i;
    }
    return SpanId._(bytes);
  }

  @override
  bool operator ==(Object other) =>
      other is SpanId && _bytesEquals(other._bytes, _bytes);

  @override
  int get hashCode => Object.hashAll(_bytes);

  String toShortString() =>
      _bytes.take(4).map((b) => b.toRadixString(16).padLeft(2, '0')).join('');

  @override
  String toString() =>
      _bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
}

final class TraceFlags {
  final int _flags;

  const TraceFlags(this._flags) : assert(_flags >= 0 && _flags <= 0xFF);

  int get value => _flags;

  static const TraceFlags sampled = TraceFlags(0x01);
  static const TraceFlags none = TraceFlags(0x00);

  bool get isSampled => _flags & 0x01 != 0;

  @override
  bool operator ==(Object other) =>
      other is TraceFlags && other._flags == _flags;

  @override
  int get hashCode => _flags.hashCode;

  @override
  String toString() => _flags.toRadixString(16).padLeft(2, '0');
}

bool _bytesEquals(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
