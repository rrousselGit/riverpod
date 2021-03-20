import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'internals.dart';

/// A function that can react to changes on a provider
///
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
@sealed
class ProviderListener<T> extends StatefulWidget {
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
  final ProviderBase<Object?, T>? provider;

  /// A function called with the new value of [provider] when it changes.
  ///
  /// This function will be called at most once per frame.
  final OnProviderChange<T> onChange;

  /// The descendant of this [ProviderListener]
  final Widget child;

  @override
  _ProviderListenerState<T> createState() => _ProviderListenerState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<OnProviderChange<T>>('onChange', onChange),
    );
    properties.add(
      DiagnosticsProperty<ProviderBase<Object?, T>>('provider', provider),
    );
  }
}

@sealed
class _ProviderListenerState<T> extends State<ProviderListener<T>> {
  ProviderSubscription<T>? _subscription;
  ProviderContainer? _container;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final container = ProviderScope.containerOf(context);

    if (container != _container) {
      _container = container;
      _listen();
    }
  }

  @override
  void didUpdateWidget(ProviderListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider) {
      _listen();
    }
  }

  void _listen() {
    _subscription?.close();
    _subscription = null;
    if (widget.provider != null) {
      _subscription = _container!.listen<T>(
        widget.provider!,
        mayHaveChanged: _mayHaveChanged,
      );
    }
  }

  void _mayHaveChanged(ProviderSubscription<T> subscription) {
    Future.microtask(() {
      if (subscription.flush()) {
        widget.onChange(context, subscription.read());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
