part of '../notifier.dart';

Provider<AsyncValue<T>> AsyncProvider<T>(
    FutureOr<void> Function(
            ProviderRef<AsyncValue<T>> ref, void Function(T value) emit)
        cb) {
  return Provider((ref) {
    ref.state = const AsyncLoading();

    var disposed = false;
    ref.onDispose(() => disposed = true);

    void emit(T value) {
      if (disposed) throw StateError('Called `emit` on a disposed provider');
    }

    Future(() => cb(ref, emit)).ignore();

    return ref.state;
  });
}

abstract class Notifier<State> extends _NotifierBase<State> {
  Ref<State> get ref => _element;

  @visibleForOverriding
  State build();
}

class NotifierProviderElement<Controller extends Notifier<State>, State>
    extends ProviderElementBase<State> {
  NotifierProviderElement(this.provider);

  @override
  final NotifierProvider<Controller, State> provider;

  late Controller notifier;

  @override
  State create() {
    // TODO test "create notifier fail"
    final notifier = this.notifier = provider._createNotifier();
    notifier._element = this;
    return notifier.build();
  }
}

class NotifierProvider<Controller extends Notifier<State>, State>
    extends AlwaysAliveProviderBase<State> {
  NotifierProvider(
    this._createNotifier, {
    String? name,
    this.dependencies,
    Family? from,
    Object? argument,
  }) : super(name: name, from: from, argument: argument);

  final Controller Function() _createNotifier;

  @override
  final List<ProviderOrFamily>? dependencies;

  late final AlwaysAliveProviderBase<Controller> notifier =
      Provider<Controller>((ref) {
    ref.watch(this);
    return (ref.container.readProviderElement(this)
            as NotifierProviderElement<Controller, State>)
        .notifier;
  });

  @override
  NotifierProviderElement<Controller, State> createElement() {
    return NotifierProviderElement<Controller, State>(this);
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return !identical(previousState, newState);
  }
}
