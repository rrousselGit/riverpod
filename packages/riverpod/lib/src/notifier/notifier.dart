part of '../notifier.dart';

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

  late final Result<Controller> _notifier =
      Result.guard(provider._createNotifier)..stateOrNull?._element = this;

  @override
  State create() => _notifier.requireState.build();

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return _notifier.stateOrNull?.updateShouldNotify(previousState, newState) ??
        true;
  }
}

class NotifierProvider<Controller extends Notifier<State>, State>
    extends AlwaysAliveProviderBase<State> {
  NotifierProvider(
    this._createNotifier, {
    super.name,
    this.dependencies,
    super.from,
    super.argument,
  }) : super();

  final Controller Function() _createNotifier;

  @override
  final List<ProviderOrFamily>? dependencies;

  late final AlwaysAliveProviderBase<Controller> notifier =
      _NotifierNotifierProvider<Controller, State>(this);

  @override
  NotifierProviderElement<Controller, State> createElement() {
    return NotifierProviderElement<Controller, State>(this);
  }
}

class _NotifierNotifierProvider<Controller extends Notifier<State>, State>
    extends AlwaysAliveProviderBase<Controller> {
  _NotifierNotifierProvider(
    this.origin, {
    super.name,
    super.from,
    super.argument,
  }) : super();

  final NotifierProvider<Controller, State> origin;

  @override
  ProviderElementBase<Controller> createElement() =>
      _NotifierNotifierProviderElement<Controller, State>(this);

  @override
  List<ProviderOrFamily>? get dependencies => origin.dependencies;
}

class _NotifierNotifierProviderElement<Controller extends Notifier<State>,
    State> extends ProviderElementBase<Controller> {
  _NotifierNotifierProviderElement(this.provider);

  @override
  final _NotifierNotifierProvider<Controller, State> provider;

  @override
  Controller create() {
    final element = container.readProviderElement(provider.origin)
        as NotifierProviderElement<Controller, State>;

// TODO
    // element.addElementListener();
    // onDispose(element.removeElementListener);

    return element._notifier.requireState;
  }

  @override
  bool updateShouldNotify(Controller previousState, Controller newState) {
    throw StateError('never reached');
  }
}
