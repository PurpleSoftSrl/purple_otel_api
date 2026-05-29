/// Vendor-specific trace state data propagated alongside a [SpanContext].
///
/// [TraceState] carries key-value pairs as defined by the W3C Trace Context
/// specification. It is transmitted in the `tracestate` header and provides
/// a mechanism for vendors to include additional trace identification data.
///
/// Construct via:
/// - [TraceState.empty()]: an empty state
/// - [TraceState.fromString()]: parsed from a W3C `tracestate` header value
///
/// Use [get] to retrieve values by key.
final class TraceState {
  final List<(String, String)> _entries;

  const TraceState._(this._entries);

  /// An empty [TraceState] with no entries.
  const TraceState.empty() : _entries = const [];

  /// Parses a [TraceState] from a W3C `tracestate` [header] string.
  ///
  /// The header is expected to be in the format `key1=value1,key2=value2`.
  /// Entries with no `=` separator are silently skipped.
  factory TraceState.fromString(String header) {
    final entries = <(String, String)>[];
    for (final member in header.split(',')) {
      final eq = member.indexOf('=');
      if (eq > 0) {
        entries.add((
          member.substring(0, eq).trim(),
          member.substring(eq + 1).trim(),
        ));
      }
    }
    return TraceState._(entries);
  }

  /// Returns the value for [key], or `null` if not present.
  String? get(String key) {
    for (final entry in _entries) {
      if (entry.$1 == key) return entry.$2;
    }
    return null;
  }

  /// Returns the W3C `tracestate` header representation.
  @override
  String toString() => _entries.map((e) => '${e.$1}=${e.$2}').join(',');
}
