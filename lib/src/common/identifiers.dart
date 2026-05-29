import 'dart:typed_data' show Uint8List;

/// A 16-byte trace identifier used to correlate [Span]s within a trace.
///
/// [TraceId] is created via:
/// - [TraceId()]: from a [Uint8List] of exactly 16 bytes
/// - [TraceId.invalid()]: an all-zero identifier representing an invalid trace
/// - [TraceId.fromBytes()]: from a [Uint8List] with a defensive copy
/// - [TraceId.generate()]: a non-cryptographic random identifier
///
/// Use [isValid] to check whether this is a non-zero identifier, and
/// [toShortString] to get a compact hex representation.
final class TraceId {
  final Uint8List _bytes;

  const TraceId._(this._bytes) : assert(_bytes.length == 16);

  /// Returns a copy of the raw 16-byte identifier.
  Uint8List get bytes => Uint8List.fromList(_bytes);

  /// Creates a [TraceId] from the given [bytes], which must be exactly 16
  /// bytes long.
  factory TraceId(Uint8List bytes) {
    if (bytes.length != 16) throw ArgumentError('TraceId must be 16 bytes');
    return TraceId._(bytes);
  }

  /// Creates an all-zero (invalid) [TraceId].
  factory TraceId.invalid() => TraceId._(Uint8List(16));

  /// Creates a [TraceId] from [bytes] by copying them defensively.
  factory TraceId.fromBytes(Uint8List bytes) =>
      TraceId._(Uint8List.fromList(bytes));

  /// Whether this [TraceId] contains at least one non-zero byte.
  bool get isValid => _bytes.any((b) => b != 0);

  /// Generates a new non-cryptographic random [TraceId].
  ///
  /// Note: this method uses the current time, not a cryptographically secure
  /// random source. For production use, override via [IdGenerator].
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

  /// Returns a compact hex string with the first 8 bytes.
  String toShortString() =>
      _bytes.take(8).map((b) => b.toRadixString(16).padLeft(2, '0')).join('');

  /// Returns the full 32-character hex representation.
  @override
  String toString() =>
      _bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
}

/// An 8-byte span identifier unique within a trace.
///
/// [SpanId] is created via:
/// - [SpanId()]: from a [Uint8List] of exactly 8 bytes
/// - [SpanId.invalid()]: an all-zero identifier representing an invalid span
/// - [SpanId.fromBytes()]: from a [Uint8List] with a defensive copy
/// - [SpanId.generate()]: a non-cryptographic random identifier
///
/// Use [isValid] to check whether this is a non-zero identifier.
final class SpanId {
  final Uint8List _bytes;

  const SpanId._(this._bytes) : assert(_bytes.length == 8);

  /// Returns a copy of the raw 8-byte identifier.
  Uint8List get bytes => Uint8List.fromList(_bytes);

  /// Creates a [SpanId] from the given [bytes], which must be exactly 8
  /// bytes long.
  factory SpanId(Uint8List bytes) {
    if (bytes.length != 8) throw ArgumentError('SpanId must be 8 bytes');
    return SpanId._(bytes);
  }

  /// Creates an all-zero (invalid) [SpanId].
  factory SpanId.invalid() => SpanId._(Uint8List(8));

  /// Creates a [SpanId] from [bytes] by copying them defensively.
  factory SpanId.fromBytes(Uint8List bytes) =>
      SpanId._(Uint8List.fromList(bytes));

  /// Whether this [SpanId] contains at least one non-zero byte.
  bool get isValid => _bytes.any((b) => b != 0);

  /// Generates a new non-cryptographic random [SpanId].
  ///
  /// Note: this method uses the current time, not a cryptographically secure
  /// random source. For production use, override via [IdGenerator].
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

  /// Returns a compact hex string with the first 4 bytes.
  String toShortString() =>
      _bytes.take(4).map((b) => b.toRadixString(16).padLeft(2, '0')).join('');

  /// Returns the full 16-character hex representation.
  @override
  String toString() =>
      _bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
}

/// W3C trace flags as defined by the W3C Trace Context specification.
///
/// [TraceFlags] encodes sampling and other bitmask flags. The [sampled]
/// flag (0x01) indicates that the trace is sampled. Use [isSampled] to
/// test the flag.
final class TraceFlags {
  final int _flags;

  /// Creates a [TraceFlags] with the given [_flags] bitmask (0-255).
  const TraceFlags(this._flags) : assert(_flags >= 0 && _flags <= 0xFF);

  /// Returns the raw flags bitmask.
  int get value => _flags;

  /// The sampled flag (0x01), indicating the trace was sampled.
  static const TraceFlags sampled = TraceFlags(0x01);

  /// An empty flags value (0x00).
  static const TraceFlags none = TraceFlags(0x00);

  /// Whether the sampled flag is set.
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
