import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:river_pod/river_pod.dart';

import 'framework.dart';
import 'internal.dart';

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
