/// A set of user-defined key-value pairs propagated across process
/// boundaries via the W3C Baggage specification.
///
/// [Baggage] carries application-defined properties through the distributed
/// context. It is immutable — mutating methods return new instances.
///
/// Construct via:
/// - [Baggage.empty()]: an empty baggage
/// - [Baggage.of()]: from an existing map of [BaggageEntry]s
///
/// Use [getEntry] to retrieve values, [setEntry] to add or update entries,
/// and [removeEntry] to remove an entry.
abstract interface class Baggage {
  /// Creates an empty [Baggage] with no entries.
  const factory Baggage.empty() = _EmptyBaggage;

  /// Creates a [Baggage] from the given [entries] map.
  ///
  /// If [entries] is empty, returns the empty [Baggage].
  factory Baggage.of(Map<String, BaggageEntry> entries) {
    if (entries.isEmpty) return const Baggage.empty();
    return _SdkBaggage(Map<String, BaggageEntry>.unmodifiable(entries));
  }

  /// Returns the number of entries in this baggage.
  int get size;

  /// Returns an iterable of the key-value entries in this baggage.
  Iterable<MapEntry<String, BaggageEntry>> get entries;

  /// Returns the [BaggageEntry] for [key], or `null` if not present.
  BaggageEntry? getEntry(String key);

  /// Returns a new [Baggage] with [value] stored under [key], optionally
  /// annotated with [metadata].
  Baggage setEntry(String key, String value, {BaggageEntryMetadata? metadata});

  /// Returns a new [Baggage] with [key] removed.
  Baggage removeEntry(String key);
}

/// A value stored in [Baggage] with optional metadata.
final class BaggageEntry {
  /// The entry's value.
  final String value;

  /// Optional metadata describing this entry.
  final BaggageEntryMetadata? metadata;

  /// Creates a [BaggageEntry] with the given [value] and optional [metadata].
  const BaggageEntry(this.value, {this.metadata});

  @override
  bool operator ==(Object other) =>
      other is BaggageEntry &&
      other.value == value &&
      other.metadata == metadata;

  @override
  int get hashCode => Object.hash(value, metadata);

  @override
  String toString() => 'BaggageEntry($value)';
}

/// Metadata associated with a [BaggageEntry].
///
/// The metadata provides additional information about the baggage entry,
/// such as its provenance or propagation constraints.
final class BaggageEntryMetadata {
  /// The metadata value.
  final String value;

  /// Creates a [BaggageEntryMetadata] with the given [value].
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
  Baggage setEntry(String key, String value,
          {BaggageEntryMetadata? metadata}) =>
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
