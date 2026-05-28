

abstract interface class Baggage {
  const factory Baggage.empty() = _EmptyBaggage;

  factory Baggage.of(Map<String, BaggageEntry> entries) {
    if (entries.isEmpty) return const Baggage.empty();
    return _SdkBaggage(Map<String, BaggageEntry>.unmodifiable(entries));
  }

  int get size;
  Iterable<MapEntry<String, BaggageEntry>> get entries;
  BaggageEntry? getEntry(String key);
  Baggage setEntry(String key, String value, {BaggageEntryMetadata? metadata});
  Baggage removeEntry(String key);
}

final class BaggageEntry {
  final String value;
  final BaggageEntryMetadata? metadata;

  const BaggageEntry(this.value, {this.metadata});

  @override
  bool operator ==(Object other) =>
      other is BaggageEntry && other.value == value && other.metadata == metadata;

  @override
  int get hashCode => Object.hash(value, metadata);

  @override
  String toString() => 'BaggageEntry($value)';
}

final class BaggageEntryMetadata {
  final String value;

  const BaggageEntryMetadata(this.value);

  @override
  bool operator ==(Object other) =>
      other is BaggageEntryMetadata && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

final class _EmptyBaggage implements Baggage {
  const _EmptyBaggage();

  @override
  int get size => 0;
  @override
  Iterable<MapEntry<String, BaggageEntry>> get entries => const [];
  @override
  BaggageEntry? getEntry(String key) => null;
  @override
  Baggage setEntry(String key, String value, {BaggageEntryMetadata? metadata}) =>
      Baggage.of({key: BaggageEntry(value, metadata: metadata)});
  @override
  Baggage removeEntry(String key) => this;
  @override
  bool operator ==(Object other) => other is _EmptyBaggage;
  @override
  int get hashCode => 0;
}

final class _SdkBaggage implements Baggage {
  final Map<String, BaggageEntry> _entries;
  const _SdkBaggage(this._entries);

  @override
  int get size => _entries.length;
  @override
  Iterable<MapEntry<String, BaggageEntry>> get entries => _entries.entries;
  @override
  BaggageEntry? getEntry(String key) => _entries[key];
  @override
  Baggage setEntry(String key, String value, {BaggageEntryMetadata? metadata}) {
    final newEntries = Map<String, BaggageEntry>.from(_entries);
    newEntries[key] = BaggageEntry(value, metadata: metadata);
    return _SdkBaggage(Map<String, BaggageEntry>.unmodifiable(newEntries));
  }
  @override
  Baggage removeEntry(String key) {
    if (!_entries.containsKey(key)) return this;
    final newEntries = Map<String, BaggageEntry>.from(_entries);
    newEntries.remove(key);
    return newEntries.isEmpty
        ? const _EmptyBaggage()
        : _SdkBaggage(Map<String, BaggageEntry>.unmodifiable(newEntries));
  }
  @override
  bool operator ==(Object other) =>
      other is _SdkBaggage && _mapEquals(other._entries, _entries);
  @override
  int get hashCode => Object.hashAll(_entries.entries);
}

bool _mapEquals(Map<String, BaggageEntry> a, Map<String, BaggageEntry> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
