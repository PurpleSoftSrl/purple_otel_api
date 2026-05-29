/// An immutable key-value store for propagating cross-cutting concerns
/// throughout a request's lifecycle.
///
/// [Context] carries values such as the active [Span], [Baggage], and
/// other contextual data. It is immutable — [withValue] returns a new
/// instance with the given key-value pair added.
///
/// Values are stored by [ContextKey] and retrieved via [get]. The
/// root context is always available as [Context.root].
final class Context {
  final Map<Symbol, Object?> _values;

  const Context._(this._values);

  /// The root context with no values.
  static const Context root = Context._({});

  /// Returns the value stored under [key], or `null` if not found.
  T? get<T>(ContextKey<T> key) => _values[key._symbol] as T?;

  /// Returns a new [Context] with [value] stored under [key].
  ///
  /// If a value already exists for [key], it is overwritten in the new
  /// context.
  Context withValue<T>(ContextKey<T> key, T value) {
    final newValues = Map<Symbol, Object?>.from(_values);
    newValues[key._symbol] = value;
    return Context._(Map.unmodifiable(newValues));
  }

  @override
  String toString() => 'Context($_values)';
}

/// A typed key for storing and retrieving values in a [Context].
///
/// [ContextKey] uses the Dart [Symbol] type internally for identity-based
/// equality, ensuring that keys are never accidentally shared across
/// different libraries.
final class ContextKey<T> {
  final Symbol _symbol;
  final String name;

  ContextKey._(this._symbol, this.name);

  /// Creates a [ContextKey] with the given [name].
  ///
  /// The [name] is used for debugging and diagnostics; the key's identity
  /// is based on a Dart [Symbol] derived from the name.
  factory ContextKey(String name) => ContextKey._(Symbol(name), name);

  @override
  bool operator ==(Object other) =>
      other is ContextKey && other._symbol == _symbol;
  @override
  int get hashCode => _symbol.hashCode;
  @override
  String toString() => 'ContextKey($name)';
}
