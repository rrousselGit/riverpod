import '../combiner.dart';
import '../common.dart';
import '../framework.dart';

part 'provider1.dart';
part 'provider_builder.dart';

extension ProviderX<T> on ProviderListenerState<ImmutableValue<T>> {
  BaseProviderState<ImmutableValue<T>, BaseProvider<ImmutableValue<T>>> get _state {
    return this as BaseProviderState<ImmutableValue<T>, BaseProvider<ImmutableValue<T>>>;
  }

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  T get value => _state.state.value;
}

abstract class Provider<T> extends BaseProvider<ImmutableValue<T>> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;

  T call();
}

class _ProviderCreate<T> extends BaseProvider<ImmutableValue<T>>
    implements Provider<T> {
  _ProviderCreate(this._create);

  final Create<T, ProviderState> _create;

  @override
  // ignore: invalid_use_of_visible_for_testing_member
  T call() => BaseProvider.use(this).value;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<ImmutableValue<Res>, _ProviderCreate<Res>> {
  @override
  ImmutableValue<Res> initState() => ImmutableValue(provider._create(this));
}
