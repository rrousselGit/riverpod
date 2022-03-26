import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import 'builders.dart';
import 'framework.dart';

part 'restorable_notifier_provider/auto_dispose.dart';
part 'restorable_notifier_provider/base.dart';

/// {@template riverpod.restorableprovider}
/// Creates a [RestorableProperty] and subscribes to it.
///
/// Note: By using Riverpod, [RestorableProperty] will no longer be O(N^2) for
/// dispatching notifications, but instead O(N)
/// {@endtemplate}
T _listenNotifier<T extends RestorableProperty<dynamic>?>(
  T notifier,
  ProviderElementBase<T> ref,
) {
  if (notifier != null) {
    void listener() {
      ref.setState(notifier);
    }

    notifier.addListener(listener);
    ref.onDispose(() {
      try {
        notifier.removeListener(listener);
        // ignore: empty_catches, may throw if called after the notifier is dispose, but this is safe to ignore.
      } catch (err) {}
    });
  }

  return notifier;
}

// ignore: subtype_of_sealed_class
/// Add [overrideWithValue] to [AutoDisposeStateNotifierProvider]
mixin RestorableProviderOverrideMixin<
        Restorable extends RestorableProperty<dynamic>?>
    on ProviderBase<Restorable> {
  ///
  ProviderBase<Restorable> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  /// 
  RestorableRestorationId withRestorationId(String restorationId) {
    return RestorableRestorationId(
      provider: this,
      restorationIdFromArg: (arg) => restorationId,
    );
  }

  /// {@macro riverpod.overrridewithvalue}
  RestorableProviderOverride overrideWithValue(
      Restorable value, String restorationId) {
    return RestorableProviderOverride(
      origin: notifier,
      override: ValueProvider<Restorable>(value),
      restorationId: restorationId,
    );
  }
}

/// Used by [ProviderScope.overrides] to register overriden providers for restoration
class RestorableProviderOverride extends ProviderOverride {
  /// Override a provider
  RestorableProviderOverride({
    required ProviderBase<RestorableProperty?> origin,
    required this.override,
    required this.restorationId,
  })  : super(origin: origin, override: override);

  /// The new provider behaviour.
  final ProviderBase<RestorableProperty?> override;

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String restorationId;
}

/// Used by [ProviderScope.restorables] to register global providers for restoration
class RestorableRestorationId {
  ///
  const RestorableRestorationId({
    required this.provider,
    required this.restorationIdFromArg,
  });

  /// The provider to restore
  final ProviderOrFamily provider;

  /// 
  final String Function(Object? arg) restorationIdFromArg;
}

// ignore: public_member_api_docs
extension RestorableProviderFamilyEx<Notifier extends RestorableProperty<dynamic>?,
    Arg> on RestorableProviderFamily<Notifier, Arg> {
  RestorableRestorationId withRestorationId(String Function(Arg arg) restorationIdFromArg) {
    return RestorableRestorationId(
      provider: this,
      restorationIdFromArg: (arg) => restorationIdFromArg(arg as Arg),
    );
  }
}

// ignore: public_member_api_docs
extension AutoDisposeRestorableProviderFamilyEx<Notifier extends RestorableProperty<dynamic>?,
    Arg> on AutoDisposeRestorableProviderFamily<Notifier, Arg> {
  RestorableRestorationId withRestorationId(String Function(Arg arg) restorationIdFromArg) {
    return RestorableRestorationId(
      provider: this,
      restorationIdFromArg: (arg) => restorationIdFromArg(arg as Arg),
    );
  }
}