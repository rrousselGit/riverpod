export 'package:riverpod/riverpod.dart';

export 'src/core.dart'
    hide ProviderScopeState, ConsumerBuilder, ConsumerStatefulElement;
// TODO changelog breaking: StateNotifier & co are no-longer exported from pkg:riverpod/riverpod.dart
//  Use pkg:riverpod/legacy.dart
