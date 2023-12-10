import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart' as test;

import '../common.dart';
import '../tenable.dart';

part 'provider_container.dart';
part 'provider_observer.dart';
part 'provider_listenable.dart';
part 'provider_element.dart';
part 'provider.dart';
part 'ref.dart';
part 'override.dart';
part 'dependency_sources/consumer.dart';
part 'dependency_sources/container.dart';
part 'dependency_sources/provider.dart';
part 'scheduler.dart';

@internal
typedef OnError = void Function(Object error, StackTrace stackTrace);

@internal
typedef ProviderListener<StateT> = void Function(
  StateT? previous,
  StateT next,
);

@internal
typedef OnAddListener = VoidCallback;
@internal
typedef OnRemoveListener = VoidCallback;
@internal
typedef OnResume = VoidCallback;
@internal
typedef OnCancel = VoidCallback;
@internal
typedef OnDispose = VoidCallback;

@internal
typedef VoidCallback = void Function();

@internal
typedef Build<T, RefT extends Ref<T>> = T Function(RefT ref);

@internal
const kDebugMode = bool.fromEnvironment('dart.vm.product');
