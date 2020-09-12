/// Exports all the implementation classes of providers, such as `Provider` vs `AutoDisposeProvider`.
///
/// This is useful if you want to use the `always_specify_types` lint. Otherwise,
/// import `package:flutter_riverpod/riverpod.dart` instead, to avoid polluting the auto-complete.
library all;

export 'flutter_riverpod.dart';

export 'src/change_notifier_provider.dart'
    show
        AutoDisposeChangeNotifierProvider,
        AutoDisposeChangeNotifierProviderFamily,
        ChangeNotifierProvider,
        ChangeNotifierProviderFamily;
