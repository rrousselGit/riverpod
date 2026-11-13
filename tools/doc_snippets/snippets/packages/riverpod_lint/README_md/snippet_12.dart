// GENERATED from packages/riverpod_lint/README.md by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Stand-ins for the providers that riverpod_generator would generate.
final rootProvider = Provider<int>((ref) => 0);
final scopedProvider = Provider<int>(dependencies: const [], (ref) => 0);
final dependencyProvider = Provider<int>((ref) => 0);

final myProvider = Provider.family<int, Object?>((ref, parameter) => 0);

class ClassThatOverridesEqual {
  @override
  bool operator ==(Object other) => other is ClassThatOverridesEqual;

  @override
  int get hashCode => 0;
}

class ClassWithNoCustomEqual {}

Object? variable;

class MyService {
  void doSomething() {}
}

final provider = Provider<MyService>((ref) => MyService());

class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => throw UnimplementedError();
}

Future<int> fetch() async => 0;

late WidgetRef ref;
late AsyncValue<int?> asyncValue;

dynamic snippet() async {
  // New instances passed as provider parameter must override ==
  ref.watch(myProvider(ClassWithNoCustomEqual()));
  // List/map/set literals do not have a custom ==
  ref.watch(myProvider([42]));
}
