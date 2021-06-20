import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'internals.dart';

/// A function that can react to changes on a provider
///
// ignore: deprecated_member_use_from_same_package
/// See also [ProviderListener]
typedef OnProviderChange<T> = void Function(BuildContext context, T value);

/// {@template riverpod.providerlistener}
/// A widget that allows listening to a provider.
///
/// A common use-case is to use [ProviderListener] to push routes/modals/snackbars
/// when the value of a provider changes.
///
/// Even if a provider changes many times in a quick succession, [onChange] will
/// be called only once, at the end of the frame.
/// {@endtemplate}
@Deprecated('Use WidgetRef.listen instead')
@sealed
class ProviderListener<T> extends ConsumerWidget {
  /// {@macro riverpod.providerlistener}
  const ProviderListener({
    Key? key,
    required this.onChange,
    required this.provider,
    required this.child,
  }) : super(key: key);

  /// The provider listened.
  ///
  /// Can be `null`.
  final ProviderListenable<T>? provider;

  /// A function called with the new value of [provider] when it changes.
  ///
  /// This function will be called at most once per frame.
  final OnProviderChange<T> onChange;

  /// The descendant of this [ProviderListener]
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (provider != null) {
      ref.listen<T>(provider!, (value) => onChange(context, value));
    }
    return child;
  }
}
