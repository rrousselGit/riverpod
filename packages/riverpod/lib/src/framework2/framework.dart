import 'dart:async';

import 'package:meta/meta.dart';

import '../result.dart';

part 'provider_container.dart';
part 'provider_observer.dart';
part 'provider_listenable.dart';
part 'provider_element.dart';
part 'provider.dart';
part 'ref.dart';
part 'override.dart';
part 'node.dart';

@internal
typedef OnError = void Function(Object error, StackTrace stackTrace);

@internal
typedef ProviderListener<StateT> = void Function(
  StateT? previous,
  StateT next,
);

@internal
typedef VoidCallback = void Function();

@internal
typedef Build<T, RefT extends Ref<T>> = T Function(RefT ref);

@internal
const kDebugMode = bool.fromEnvironment('dart.vm.product');
