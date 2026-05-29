final class TraceState {
  final List<(String, String)> _entries;

  const TraceState._(this._entries);

  const TraceState.empty() : _entries = const [];

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

  String? get(String key) {
    for (final entry in _entries) {
      if (entry.$1 == key) return entry.$2;
    }
    return null;
  }

  @override
  String toString() => _entries.map((e) => '${e.$1}=${e.$2}').join(',');
}
