import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_class_based_provider_to_functional.g.dart';

/// Some comment
@riverpod
class Example extends _$Example {
  @override
  int build() => 0;
}

/// Some comment
@riverpod
class ExampleFamily extends _$ExampleFamily {
  @override
  int build({required int a, String b = '42'}) {
    // Hello world
    return 0;
  }
}

@riverpod
class Generic<A, /* comment */ B> extends _$Generic<A, B> {
  @override
  int build() => 0;
}

class Foo extends StatelessWidget {
  const Foo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: const Placeholder());
  }
}
