import '../framework.dart';

class FFamily<RefT extends Ref<R>, R, Arg, Created,
    ProviderT extends ProviderBase<R>> extends Family<R, Arg, ProviderT> {
  FFamily(
    this._createFn, {
    required ProviderT Function(
      Create<Created, RefT> create, {
      String? name,
      Family from,
      Object? argument,
      List<ProviderOrFamily>? dependencies,
    })
        providerFactory,
    required super.name,
    required super.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  }) : _providerFactory = providerFactory;

  final ProviderT Function(
    Create<Created, RefT> create, {
    String? name,
    Family from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
      );
}
