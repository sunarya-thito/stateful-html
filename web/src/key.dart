abstract class Key {
  const Key.empty();
}

abstract class LocalKey extends Key {
  const LocalKey() : super.empty();
}

class UniqueKey extends LocalKey {
  UniqueKey();

  @override
  String toString() =>
      '[#${hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0')}]';
}

class ValueKey<T> extends LocalKey {
  const ValueKey(this.value);

  final T value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ValueKey<T> && other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    final String valueString = T == String ? '<\'$value\'>' : '<$value>';
    if (runtimeType == _TypeLiteral<ValueKey<T>>().type) {
      return '[$valueString]';
    }
    return '[$T $valueString]';
  }
}

class _TypeLiteral<T> {
  Type get type => T;
}
