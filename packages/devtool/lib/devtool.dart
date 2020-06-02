import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/src/internals.dart';

import 'state_notifier_builder.dart';

part 'devtool.freezed.dart';

@freezed
abstract class DevtoolThemeData with _$DevtoolThemeData {
  factory DevtoolThemeData({
    @required Color backgroundColor,
    @required TextStyle name,
    @required TextStyle type,
    @required TextStyle hash,
    @required TextStyle valueFallback,
    @required TextStyle stringValue,
    @required TextStyle intValue,
    @required TextStyle doubleValue,
    @required TextStyle stepperLabel,
    @required EdgeInsets providerMargin,
    @required EdgeInsets otherMargin,
    @required EdgeInsets padding,
  }) = _DevtoolThemeData;

  factory DevtoolThemeData.fallback() {
    return DevtoolThemeData(
      backgroundColor: Colors.blueGrey.shade800,
      name: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      valueFallback: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      type: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 14,
      ),
      hash: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      stringValue: const TextStyle(
        color: Colors.orangeAccent,
        fontSize: 14,
      ),
      intValue: const TextStyle(
        color: Colors.lightGreenAccent,
        fontSize: 14,
      ),
      doubleValue: const TextStyle(
        color: Colors.lightGreenAccent,
        fontSize: 14,
      ),
      stepperLabel: const TextStyle(
        color: Colors.white,
      ),
      providerMargin: const EdgeInsets.only(top: 5),
      otherMargin: const EdgeInsets.symmetric(vertical: 2.5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    );
  }
}

class DevtoolTheme extends InheritedWidget {
  const DevtoolTheme({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  static DevtoolThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DevtoolTheme>()?.data;
  }

  final DevtoolThemeData data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class Devtool extends HookWidget {
  const Devtool({Key key, this.controller}) : super(key: key);

  final DevtoolController controller;

  @override
  Widget build(BuildContext context) {
    final indexFromEnd = useState(0);
    final theme = DevtoolTheme.of(context) ?? DevtoolThemeData.fallback();

    return Container(
      padding: theme.padding,
      color: theme.backgroundColor,
      child: StateNotifierBuilder<StateDetail>(
        stateNotifier: controller,
        builder: (context, value, _) {
          StateSnapshot snapshot;
          if (value.history.isNotEmpty) {
            snapshot =
                value.history[value.history.length - 1 - indexFromEnd.value];
          } else {
            snapshot = value.currentSnapshot;
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: _StateTree(
                  key: ValueKey(snapshot.details),
                  details: snapshot.details,
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: indexFromEnd.value + 1 >= value.history.length
                        ? null
                        : () => indexFromEnd.value++,
                    child: Text('previous'),
                  ),
                  Text(
                    '${value.history.length - indexFromEnd.value} / ${value.history.length}',
                    style: theme.stepperLabel,
                  ),
                  RaisedButton(
                    onPressed: indexFromEnd.value == 0
                        ? null
                        : () => indexFromEnd.value--,
                    child: Text('next'),
                  ),
                  RaisedButton(
                    onPressed: indexFromEnd.value == 0
                        ? null
                        : () {
                            for (final detail in snapshot.details) {
                              if (detail.rebuild != null) {
                                detail.rebuild(detail.value);
                              }
                            }
                            indexFromEnd.value = 0;
                          },
                    child: Text('restore'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StateTree extends StatelessWidget {
  const _StateTree({
    Key key,
    this.details,
  }) : super(key: key);

  final List<_PropertyDetail> details;

  @override
  Widget build(BuildContext context) {
    final theme = DevtoolTheme.of(context) ?? DevtoolThemeData.fallback();
    return ListView(
      children: [
        for (final detail in details)
          Container(
            padding: detail.value is ProviderBase
                ? theme.providerMargin
                : theme.otherMargin,
            child: Row(
              children: [
                SizedBox(width: detail.depth * 20.0),
                if (detail.name != null)
                  Text('${detail.name}: ', style: theme.name),
                if (detail.value is int)
                  Flexible(
                    child: TextFormField(
                      initialValue: detail.valueDisplay,
                      enabled: detail.rebuild != null,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      onFieldSubmitted: (v) => detail.rebuild(int.tryParse(v)),
                      style: theme.intValue,
                    ),
                  )
                else if (detail.value is double)
                  Flexible(
                    child: TextFormField(
                      initialValue: detail.valueDisplay,
                      enabled: detail.rebuild != null,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      onFieldSubmitted: (v) => detail.rebuild(double.tryParse(v)),
                      style: theme.doubleValue,
                    ),
                  )
                else if (detail.value is String)
                  Flexible(
                    child: TextFormField(
                      initialValue: detail.valueDisplay,
                      enabled: detail.rebuild != null,
                      onFieldSubmitted: detail.rebuild,
                      style: theme.stringValue,
                    ),
                  )
                else if (detail.value is bool)
                  Checkbox(
                    value: detail.value as bool,
                    onChanged: detail.rebuild,
                  )
                else if (detail.valueDisplay != null)
                  Text(detail.valueDisplay, style: theme.valueFallback),
                if (detail.type != null)
                  Flexible(
                    child: Text(
                      detail.type,
                      style: theme.type,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (detail.hash != null)
                  Text('#${detail.hash}', style: theme.hash),
              ],
            ),
          ),
      ],
    );
  }
}

Iterable<_PropertyDetail> _parseProperties(
  Map<ProviderBase, Object> providers,
) sync* {
  final entries = providers.entries.toList()
    ..sort((a, b) {
      if (a.key.name != null || b.key.name != null) {
        if (a.key.name == null) {
          return 1;
        }
        if (b.key.name == null) {
          return -1;
        }
        return a.key.name.compareTo(b.key.name);
      }

      return '${a.key.runtimeType}'.compareTo('${b.key.runtimeType}');
    });

  for (final entry in entries) {
    yield* _parseValue(entry.key, name: entry.key.name);
    yield* _parseValue(
      entry.value,
      depth: 1,
      rebuild: entry.key is StateNotifierValueProvider
          ? (value) {
              final controller = providers[
                      (entry.key as StateNotifierValueProvider).controller]
                  as StateNotifier;

              // ignore: invalid_use_of_protected_member
              controller.state = value;
            }
          : null,
    );
  }
}

// TODO: changing freezed constructor
// TODO adding/removing to list
// TODO assign to null (and handle non-nullables)
// TODO late properties
// TODO List/Map
// TODO emums

Iterable<_PropertyDetail> _parseValue(
  Object value, {
  String name,
  void Function(Object) rebuild,
  int depth = 0,
}) sync* {
  if (value is $DebugFreezed) {
    yield _PropertyDetail(
      // TODO: generics
      value: value,
      type: value.$debugRedirectedClassName,
      hash: shortHash(value.hashCode),
      name: name,
      depth: depth,
    );
    final copyWith = (value as dynamic).copyWith.call as Object Function();
    for (final entry in value.$debugToMap().entries) {
      yield* _parseValue(
        entry.value,
        name: entry.key,
        rebuild: rebuild == null
            ? null
            : (value) {
                return rebuild(
                  Function.apply(copyWith, const <Object>[], <Symbol, Object>{
                    Symbol(entry.key): value,
                  }),
                );
              },
        depth: depth + 1,
      );
    }
  } else if (value is Diagnosticable) {
    final propertiesBuilder = DiagnosticPropertiesBuilder();
    // ignore: invalid_use_of_protected_member
    value.debugFillProperties(propertiesBuilder);

    yield _PropertyDetail(
      type: '${value.runtimeType}',
      value: value,
      hash: shortHash(value.hashCode),
      name: name,
      depth: depth,
    );
    for (final property in propertiesBuilder.properties) {
      yield* _parseValue(
        property.value,
        name: property.name,
        depth: depth + 1,
      );
    }
  } else if (value is ProviderBase) {
    yield _PropertyDetail(
      value: value,
      type: value.runtimeType.toString(),
      hash: shortHash(value.hashCode),
      depth: depth,
      name: name,
    );
  } else {
    final isPrimitiveValue = value is num ||
        value is Iterable ||
        value is Map ||
        value is bool ||
        value is String;
    yield _PropertyDetail(
      value: value,
      valueDisplay: '$value',
      type: isPrimitiveValue ? null : value.runtimeType.toString(),
      hash: isPrimitiveValue ? null : shortHash(value.hashCode),
      depth: depth,
      rebuild:
          value is num || value is bool || value is String ? rebuild : null,
      name: name,
    );
  }
}

@freezed
abstract class _PropertyDetail with _$_PropertyDetail {
  factory _PropertyDetail({
    @required Object value,
    @required int depth,
    String name,
    String valueDisplay,
    void Function(Object) rebuild,
    String type,
    String hash,
  }) = __PropertyDetail;
}

@freezed
abstract class StateSnapshot with _$StateSnapshot {
  factory StateSnapshot({
    @required Map<ProviderBase, Object> state,
    @required List<_PropertyDetail> details,
  }) = _StateSnapshot;
}

@freezed
abstract class StateDetail with _$StateDetail {
  factory StateDetail({
    @required List<StateSnapshot> history,
  }) = _StateDetail;
  StateDetail._();

  Map<ProviderBase, Object> get currentState {
    return history.isNotEmpty ? history.last.state : {};
  }

  StateSnapshot get currentSnapshot {
    return history.isNotEmpty
        ? history.last
        : StateSnapshot(
            state: {},
            details: [],
          );
  }
}

class DevtoolController extends StateNotifier<StateDetail>
    implements ProviderStateOwnerObserver {
  DevtoolController() : super(StateDetail(history: []));

  @override
  void didAddProvider(ProviderBase provider, Object value) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final newState = {...state.currentSnapshot.state, provider: value};

      final newHistory = [...state.history];
      if (newHistory.isNotEmpty) {
        newHistory.removeLast();
      }
      newHistory.add(
        StateSnapshot(
          state: newState,
          details: _parseProperties(newState).toList(),
        ),
      );

      state = StateDetail(history: newHistory);
    });
  }

  @override
  void didUpdateProviders(Map<ProviderBase, Object> changes) {
    final newState = {...?state.currentState, ...changes};
    state = StateDetail(
      history: [
        ...state.history,
        StateSnapshot(
          state: newState,
          details: _parseProperties(newState).toList(),
        ),
      ],
    );
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    final newState = {...?state.currentState}..remove(provider);
    state = StateDetail(
      history: [
        ...state.history,
        StateSnapshot(
          state: newState,
          details: _parseProperties(newState).toList(),
        ),
      ],
    );
  }
}
