import '../../result.dart';
import '../framework.dart';

abstract base class SyncProvider<StateT> extends Provider<StateT> {
  const SyncProvider({
    required super.name,
    required super.from,
    required super.arguments,
    required super.debugSource,
  });

  StateT build(Ref<StateT> ref);

  Override overrideWith(Build<StateT, Ref<StateT>> create);

  Override overrideWithValue(StateT value);

  @override
  SyncProviderElement<StateT> createElement() => SyncProviderElement(this);
}

class SyncProviderElement<StateT> extends ProviderElement<StateT> {
  SyncProviderElement(this.provider);

  final SyncProvider<StateT> provider;

  @override
  void build(Ref<StateT> ref) {
    try {
      result = Result.data(provider.build(ref));
    } catch (err, stack) {
      result = Result.error(err, stack);
    }
  }
}
