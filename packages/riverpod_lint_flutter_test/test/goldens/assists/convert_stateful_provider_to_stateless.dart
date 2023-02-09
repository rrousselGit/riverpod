import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_stateful_provider_to_stateless.g.dart';

/// Some comment
@riverpod
class Stateful extends _$Stateful {
  @override
  int build() => 0;
}

/// Some comment
@riverpod
class StatefulFamily extends _$StatefulFamily {
  @override
  int build({required int a, String b = '42'}) {
    // Hello world
    return 0;
  }
}
