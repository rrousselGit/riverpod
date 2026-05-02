extension Let<InT> on InT? {
  OutT? let<OutT>(OutT Function(InT it) op) {
    final thisValue = this;
    if (thisValue == null) return null;

    return op(thisValue);
  }

  OutT Function()? bind<OutT>(OutT Function(InT it) op) {
    final thisValue = this;
    if (thisValue == null) return null;

    return () => op(thisValue);
  }
}
