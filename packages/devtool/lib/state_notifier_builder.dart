import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';

/// {@template flutter_state_notifier.state_notifier_builder}
/// Listens to a [StateNotifier] and use it builds a widget tree based on the
/// latest value.
///
/// This is similar to [ValueListenableBuilder] for [ValueNotifier].
/// {@endtemplate}
class StateNotifierBuilder<T> extends StatefulWidget {
  /// {@macro flutter_state_notifier.state_notifier_builder}
  const StateNotifierBuilder({
    Key key,
    @required this.builder,
    @required this.stateNotifier,
    this.child,
  })  : assert(builder != null, ''),
        assert(stateNotifier != null, ''),
        super(key: key);

  /// A callback that builds a [Widget] based on the current value of [stateNotifier]
  ///
  /// Cannot be `null`.
  final ValueWidgetBuilder<T> builder;

  /// The listened [StateNotifier].
  ///
  /// Cannot be `null`.
  final StateNotifier<T> stateNotifier;

  /// A cache of a subtree that does not depend on [stateNotifier].
  ///
  /// It will be sent untouched to [builder]. This is useful for performance
  /// optimizations to not rebuild the entire widget tree if it isn't needed.
  final Widget child;

  @override
  _StateNotifierBuilderState<T> createState() =>
      _StateNotifierBuilderState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<StateNotifier<T>>('stateNotifier', stateNotifier),
      )
      ..add(DiagnosticsProperty<Widget>('child', child))
      ..add(ObjectFlagProperty<ValueWidgetBuilder<T>>.has('builder', builder));
  }
}

class _StateNotifierBuilderState<T> extends State<StateNotifierBuilder<T>> {
  T state;
  VoidCallback removeListener;

  @override
  void initState() {
    super.initState();
    _listen(widget.stateNotifier);
  }

  @override
  void didUpdateWidget(StateNotifierBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stateNotifier != oldWidget.stateNotifier) {
      _listen(widget.stateNotifier);
    }
  }

  void _listen(StateNotifier<T> notifier) {
    removeListener?.call();
    removeListener = notifier.addListener(_listener);
  }

  void _listener(T value) {
    setState(() => state = value);
  }

  @override
  void dispose() {
    removeListener?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, state, widget.child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('state', state));
  }
}
