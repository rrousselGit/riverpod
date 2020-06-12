import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internal.dart';

extension AlwaysAliveProviderX<Dependency extends ProviderDependencyBase,
    Result> on AlwaysAliveProvider<Dependency, Result> {
  Result read(BuildContext context) {
    assert(() {
      if (context.debugDoingBuild) {
        throw UnsupportedError(
          'Cannot call `provider.read(context)` inside `build`',
        );
      }
      return true;
    }(), '');

    return readOwner(ProviderStateOwnerScope.of(context, listen: false));
  }
}
