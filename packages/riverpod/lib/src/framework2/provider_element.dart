part of 'framework.dart';

abstract class ProviderElement<StateT> {
  Result<StateT>? _result;
  Result<StateT>? get result => _result;
  set result(Result<StateT>? value) => _result = value;

  FutureOr<void> build(Ref<StateT> ref);

  void markNeedsReload() {
    throw UnimplementedError();
  }

  void markNeedsRefresh() {
    throw UnimplementedError();
  }
}
