import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

extension AlwaysAliveProviderX<CombiningValue extends ProviderBaseSubscription,
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
