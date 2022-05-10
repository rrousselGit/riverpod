part of '../notifier.dart';

abstract class Notifier<State> extends _NotifierBase<State> {
  Ref<State> get ref => _element;

  @visibleForOverriding
  State init();
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
    return notifier.init();
  }
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
  NotifierProviderElement<Controller, State> createElement() {
    return NotifierProviderElement<Controller, State>(this);
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return identical(previousState, newState);
  }
}
