import 'span_kind.dart' show StatusCode;

final class SpanStatus {
  final StatusCode code;
  final String? description;

  const SpanStatus(this.code, {this.description});

  static const SpanStatus unset = SpanStatus(StatusCode.unset);
  static const SpanStatus ok = SpanStatus(StatusCode.ok);

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
