import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

extension BaseProviderHook<T> on BaseProvider<BaseProviderValue, T> {
  T call() => useProvider(this);
}

extension AlwaysAliveProviderX<CombiningValue extends BaseProviderValue,
    ListenedValue> on AlwaysAliveProvider<CombiningValue, ListenedValue> {
  ListenedValue read(BuildContext context) {
    assert(() {
      if (context.debugDoingBuild) {
        throw UnsupportedError(
            'Cannot call `provider.read(context)` inside `build`');
      }
      return true;
    }(), '');

    return readOwner(ProviderStateOwnerScope.of(context, listen: false));
  }
}
