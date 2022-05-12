part of '../notifier.dart';

abstract class NotifierFamily<State, Arg> extends _NotifierBase<State> {
  Ref<State> get ref => _element;

  late final Arg argument;

  @visibleForOverriding
  State init(Arg argument);
}

class NotifierProviderFamilyElement<
    Controller extends NotifierFamily<State, Arg>,
    State,
    Arg> extends ProviderElementBase<State> {
  NotifierProviderFamilyElement(this.provider);

  @override
  final NotifierProviderFamily<Controller, State, Arg> provider;

  late Controller notifier;

  @override
  State create() {
    // TODO test "create notifier fail"
    final notifier = this.notifier = provider._createNotifier();
    notifier._element = this;
    return notifier.init(provider.argument as Arg);
  }
}

class NotifierProviderFamily<Controller extends NotifierFamily<State, Arg>,
    State, Arg> extends AlwaysAliveProviderBase<State> {
  NotifierProviderFamily(
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
            as NotifierProviderFamilyElement<Controller, State, Arg>)
        .notifier;
  });

  @override
  NotifierProviderFamilyElement<Controller, State, Arg> createElement() {
    return NotifierProviderFamilyElement<Controller, State, Arg>(this);
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return identical(previousState, newState);
  }
}
