import '../combiner.dart';
import '../framework.dart';

part 'provider1.dart';
part 'provider_builder.dart';

/// A placeholder used by [Provider]/[ProviderX].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class ProviderValue<T> {
  const ProviderValue(this._value);
  final T _value;
}

extension ProviderX<T> on ProviderListenerState<ProviderValue<T>> {
  T get value => $instance._value;
}

abstract class Provider<T> extends BaseProvider<ProviderValue<T>> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;

  T call();
}

class _ProviderCreate<T> extends BaseProvider<ProviderValue<T>>
    implements Provider<T> {
  _ProviderCreate(this._create);

  final Create<T, ProviderState> _create;

  @override
  // ignore: invalid_use_of_visible_for_testing_member
  T call() => BaseProvider.use(this)._value;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<ProviderValue<Res>, _ProviderCreate<Res>> {
  @override
  ProviderValue<Res> initState() => ProviderValue(provider._create(this));
}
