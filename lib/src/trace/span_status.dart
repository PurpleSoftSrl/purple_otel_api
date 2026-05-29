import 'span_kind.dart' show StatusCode;

/// The status of a completed [Span], applied via [Span.setStatus].
///
/// The status consists of a [StatusCode] and an optional human-readable
/// [description]. Use the static constants [SpanStatus.unset] and
/// [SpanStatus.ok] for common cases, or [SpanStatus.error] for failures.
final class SpanStatus {
  /// The [StatusCode] for this status.
  final StatusCode code;

  /// An optional human-readable description of the status.
  final String? description;

  /// Creates a [SpanStatus] with the given [code] and optional [description].
  const SpanStatus(this.code, {this.description});

  /// The default unset status — equivalent to `StatusCode.unset`.
  static const SpanStatus unset = SpanStatus(StatusCode.unset);

  /// A successful status — equivalent to `StatusCode.ok`.
  static const SpanStatus ok = SpanStatus(StatusCode.ok);

  /// An error status with an optional [description] — equivalent to
  /// `StatusCode.error`.
  factory SpanStatus.error([String? description]) =>
      SpanStatus(StatusCode.error, description: description);

  @override
  bool operator ==(Object other) =>
      other is SpanStatus &&
      other.code == code &&
      other.description == description;

  @override
  int get hashCode => Object.hash(code, description);

  @override
  String toString() => 'SpanStatus($code, $description)';
}
