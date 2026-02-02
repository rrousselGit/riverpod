extension Let<T> on T? {
  R? let<R>(R Function(T it) op) {
    final thisValue = this;
    if (thisValue == null) return null;

    return op(thisValue);
  }

  R Function()? bind<R>(R Function(T it) op) {
    final thisValue = this;
    if (thisValue == null) return null;

    return () => op(thisValue);
  }
}
