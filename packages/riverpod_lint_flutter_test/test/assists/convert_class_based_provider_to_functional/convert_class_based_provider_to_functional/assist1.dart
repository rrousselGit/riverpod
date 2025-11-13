// GENERATED CODE - DO NOT MODIFY BY HAND
// [riverpod.wrap_with_consumer?offset=686,697]

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assist1.g.dart';

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
    return Container(child: Consumer(builder: (context, ref, child) { return const Placeholder(); },));
  }
}
