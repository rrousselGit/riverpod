import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('Change Notifier listening syntax', () {
    test('StateProvider', () {
      final sourceFile = SourceFile.fromString(r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 1);
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider).state;
    return Container(
      child: Text('$count'),
    );
  }
}

''');
      const expectedOutput = r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 1);
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Container(
      child: Text('$count'),
    );
  }
}

''';

      final patches = RiverpodNotifierChangesMigrationSuggestor()
          .generatePatches(sourceFile);
      expect(patches, hasLength(1));
      expect(applyPatches(sourceFile, patches), expectedOutput);
    });

    test('StateNotifierProvider', () {
      final sourceFile = SourceFile.fromString(r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  const Counter(): super(1);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider((ref) => Counter());
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider).state;
    return Container(
      child: Text('$count'),
    );
  }
}

''');
      const expectedOutput = r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  const Counter(): super(1);
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = StateNotifierProvider((ref) => Counter());
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Container(
      child: Text('$count'),
    );
  }
}

''';
      final patches = RiverpodNotifierChangesMigrationSuggestor()
          .generatePatches(sourceFile);
      expect(patches, hasLength(1));
      expect(applyPatches(sourceFile, patches), expectedOutput);
    });

    test('ChangeNotifierProvider', () {
      final sourceFile = SourceFile.fromString(r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends ChangeNotifier {
  const Counter();
  int _state = 0;
  int get state => _state;
  void increment() {
    state++;
    notifyListeners();
  }
  void decrement() {
    state++;
    notifyListeners();
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Container(
      child: Text('$count'),
    );
  }
}

''');
      const expectedOutput = r'''
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends ChangeNotifier {
  const Counter();
  int _state = 0;
  int get state => _state;
  void increment() {
    state++;
    notifyListeners();
  }
  void decrement() {
    state++;
    notifyListeners();
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());
class ConsumerWatch extends ConsumerWidget {
  const ConsumerWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final count = watch(counterProvider);
    return Container(
      child: Text('$count'),
    );
  }
}

''';
      final patches = RiverpodNotifierChangesMigrationSuggestor()
          .generatePatches(sourceFile);
      expect(patches, hasLength(0));
      expect(applyPatches(sourceFile, patches), expectedOutput);
    });
  });
}
