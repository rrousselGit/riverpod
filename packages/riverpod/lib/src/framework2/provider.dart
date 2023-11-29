part of 'framework.dart';

abstract class ProviderListenableOrFamily {}

abstract class ProviderOrFamily {}

abstract base class Family implements ProviderOrFamily {
  const Family();
}

@immutable
@renameProviderBaseToPRovider()
abstract base class Provider<StateT>
    with ProviderListenable<StateT>
    implements ProviderOrFamily {
  const Provider({
    required this.name,
    required this.from,
    required this.arguments,
    required this.debugSource,
  });

  final String name;
  final Family? from;
  final String? debugSource;

  @Deprecated('Use arguments')
  Object? get argument => arguments;
  final Object? arguments;
}
