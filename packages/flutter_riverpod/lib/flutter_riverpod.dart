// ignore: invalid_export_of_internal_element, Already tackled by riverpod/riverpod.dart. If we export internals, that's on purpose.
export 'package:riverpod/riverpod.dart';

export 'src/core.dart'
    hide ProviderScopeState, ConsumerBuilder, ConsumerStatefulElement;
// TODO changelog breaking: StateNotifier & co are no-longer exported from pkg:riverpod/riverpod.dart
//  Use pkg:riverpod/legacy.dart
