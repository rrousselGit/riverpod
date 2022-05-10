part of '../notifier.dart';

abstract class Notifier<State> extends _NotifierBase<State> {
  Ref<State> get ref => _element;

  @visibleForOverriding
  State init();
}

class NotifierProviderElement<Controller extends Notifier<State>, State>
    extends ProviderElementBase<State> {
  NotifierProviderElement(NotifierProvider<Controller, State> provider)
      : super(provider);

  late Controller notifier;
}

class NotifierProvider<Controller extends Notifier<State>, State>
    extends ProviderBase<State> {
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

  @override
  State create(
    covariant NotifierProviderElement<Controller, State> ref,
  ) {
    // TODO test "create notifier fail"
    final notifier = ref.notifier = _createNotifier().._element = ref;
    return notifier.init();
  }

  @override
  NotifierProviderElement<Controller, State> createElement() {
    return NotifierProviderElement<Controller, State>(this);
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return identical(previousState, newState);
  }
}
