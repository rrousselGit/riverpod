import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'builders.dart';
import 'framework.dart';
import 'future_provider.dart';
import 'provider.dart';
import 'value_provider.dart';

part 'state_notifier_provider/auto_dispose.dart';
part 'state_notifier_provider/base.dart';

/// Add [overrideWithValue] to [AutoDisposeStateNotifierProvider]
mixin StateNotifierProviderOverrideMixin<Notifier extends StateNotifier<State>,
    State> on ProviderBase<State> {
  ///
  ProviderBase<Notifier> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  /// {@macro riverpod.overrridewithvalue}
  Override overrideWithValue(Notifier value) {
    return ProviderOverride(
      origin: notifier,
      override: ValueProvider<Notifier>(value),
    );
  }
}
