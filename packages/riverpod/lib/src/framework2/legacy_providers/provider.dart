@riverpod
T provider<T>(ProviderRef<T> ref, T Function(ProviderRef<T> ref) create) {
  return create(ref);
}
