final class Context {
  final Map<Symbol, Object?> _values;

  const Context._(this._values);

  static const Context root = Context._({});

  T? get<T>(ContextKey<T> key) => _values[key._symbol] as T?;

  Context withValue<T>(ContextKey<T> key, T value) {
    final newValues = Map<Symbol, Object?>.from(_values);
    newValues[key._symbol] = value;
    return Context._(Map.unmodifiable(newValues));
  }

  @override
  String toString() => 'Context($_values)';
}

final class ContextKey<T> {
  final Symbol _symbol;
  final String name;

  ContextKey._(this._symbol, this.name);

  factory ContextKey(String name) => ContextKey._(Symbol(name), name);

  @override
  bool operator ==(Object other) => other is ContextKey && other._symbol == _symbol;
  @override
  int get hashCode => _symbol.hashCode;
  @override
  String toString() => 'ContextKey($name)';
}
