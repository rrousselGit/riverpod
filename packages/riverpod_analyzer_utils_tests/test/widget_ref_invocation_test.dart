import 'package:riverpod_analyzer_utils/src/nodes.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

// ignore: invalid_use_of_internal_member
extension on RiverpodAnalysisResult {
  List<WidgetRefWatchInvocation> get widgetRefWatchInvocations {
    return widgetRefInvocations.cast();
  }

  List<WidgetRefReadInvocation> get widgetRefReadInvocations {
    return widgetRefInvocations.cast();
  }

  List<WidgetRefListenInvocation> get widgetRefListenInvocations {
    return widgetRefInvocations.cast();
  }

  List<WidgetRefListenManualInvocation> get widgetRefListenManualInvocations {
    return widgetRefInvocations.cast();
  }
}

void main() {
  testSource('Decode watch expressions with syntax errors', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

@ProviderFor(gibberish)
final gibberishProvider = Provider((ref) => 0);

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(gibberishProvider);
    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult(
      ignoreErrors: true,
    );

    expect(result.widgetRefWatchInvocations, hasLength(1));
    expect(result.widgetRefInvocations.single.function.toSource(), 'watch');
    expect(
      result.widgetRefInvocations.single.node.toSource(),
      'ref.watch(gibberishProvider)',
    );
    expect(
      result.widgetRefWatchInvocations.single.listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations.single.listenable.node.toSource(),
      'gibberishProvider',
    );
    expect(result.widgetRefWatchInvocations.single.listenable.provider, isNull);
  });

  testSource('Decodes ..watch', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(dep)
      ..watch(dep2Provider)
      ..watch(dep3Provider);

    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      '..watch(dep)',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].listenable.node.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.node.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      '..watch(dep2Provider)',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].listenable.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.familyArguments,
      null,
    );

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      '..watch(dep3Provider)',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].listenable.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.familyArguments,
      null,
    );
  });

  testSource('Decodes simple ref.watch usages', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

extension on WidgetRef {
  void fn() {}
}

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dep);
    ref.watch(dep2Provider);
    ref.watch(dep3Provider);

    ref.fn();
    return Container();
  }
}

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(dep);
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(dep)',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].listenable.node.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.node.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider)',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].listenable.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.familyArguments,
      null,
    );

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      'ref.watch(dep3Provider)',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].listenable.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.familyArguments,
      null,
    );
  });

  testSource('Decodes unknown ref usages', source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dep = FutureProvider((ref) => 0);
final dep2 = FutureProvider((ref) => 0);

void fn(WidgetRef ref) {
  ref.read(dep);
  ref.read(dep2);
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefInvocations, hasLength(2));
    expect(
      result.widgetRefReadInvocations,
      result.widgetRefInvocations,
    );
    expect(result.widgetRefInvocations, result.widgetRefReadInvocations);

    expect(result.widgetRefReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.widgetRefReadInvocations[0].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefReadInvocations[1].node.toSource(),
      'ref.read(dep2)',
    );
    expect(result.widgetRefReadInvocations[1].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[1].listenable.provider?.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('dep2').providerElement,
      ),
    );
  });

  testSource('Decodes ref.listen usages', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<int>>(dep, (prev, next) {});
    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefListenInvocations, hasLength(1));
    expect(result.widgetRefInvocations, result.widgetRefListenInvocations);

    expect(
      result.widgetRefListenInvocations[0].node.toSource(),
      'ref.listen<AsyncValue<int>>(dep, (prev, next) {})',
    );
    expect(result.widgetRefListenInvocations[0].function.toSource(), 'listen');
    expect(
      result.widgetRefListenInvocations[0].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.widgetRefListenInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );
  });

  testSource('Decodes ref.listenManual usages', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenManual<AsyncValue<int>>(dep, (prev, next) {});
    ref.listenManual<AsyncValue<int>>(dep, (prev, next) {}, fireImmediately: true);
    ref.listenManual<AsyncValue<int>>(fireImmediately: true, dep, (prev, next) {});
    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefListenManualInvocations, hasLength(3));
    expect(
      result.widgetRefInvocations,
      result.widgetRefListenManualInvocations,
    );

    expect(
      result.widgetRefListenManualInvocations[0].node.toSource(),
      'ref.listenManual<AsyncValue<int>>(dep, (prev, next) {})',
    );
    expect(
      result.widgetRefListenManualInvocations[0].function.toSource(),
      'listenManual',
    );
    expect(
      result.widgetRefListenManualInvocations[0].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.widgetRefListenManualInvocations[0].listenable.provider
          ?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefListenManualInvocations[1].node.toSource(),
      'ref.listenManual<AsyncValue<int>>(dep, (prev, next) {}, fireImmediately: true)',
    );
    expect(
      result.widgetRefListenManualInvocations[1].function.toSource(),
      'listenManual',
    );
    expect(
      result.widgetRefListenManualInvocations[1].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.widgetRefListenManualInvocations[1].listenable.provider
          ?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefListenManualInvocations[2].node.toSource(),
      'ref.listenManual<AsyncValue<int>>(fireImmediately: true, dep, (prev, next) {})',
    );
    expect(
      result.widgetRefListenManualInvocations[2].function.toSource(),
      'listenManual',
    );
    expect(
      result.widgetRefListenManualInvocations[2].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.widgetRefListenManualInvocations[2].listenable.provider
          ?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );
  });

  testSource('Decodes ref.read usages', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);
final dep2 = FutureProvider((ref) => 0);


class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(dep);
    ref.read(dep2);

    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefReadInvocations, hasLength(2));
    expect(result.widgetRefInvocations, result.widgetRefReadInvocations);

    expect(result.widgetRefReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.widgetRefReadInvocations[0].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefReadInvocations[1].node.toSource(),
      'ref.read(dep2)',
    );
    expect(result.widgetRefReadInvocations[1].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[1].listenable.provider?.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('dep2').providerElement,
      ),
    );
  });

  testSource('Decodes family ref.watch usages', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

extension on WidgetRef {
  void fn() {}
}

final family = FutureProvider.family<int, int>((ref, id) => 0);

@Riverpod(keepAlive: true)
Future<int> family2(Family2Ref ref, {required int id}) async => 0;

@Riverpod(keepAlive: true)
class Family3 extends _$Family3 {
  @override
  Future<int> build({required int id}) async => 0;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(family(0));
    ref.watch(family2Provider(id: 0));
    ref.watch(family3Provider(id: 0));

    return Container();
  }
}

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(family(0));
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final providerRefInvocations = result.widgetRefInvocations;

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);
    expect(result.widgetRefWatchInvocations, providerRefInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(family(0))',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].listenable.node.toSource(),
      'family(0)',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.node.toSource(),
      'family',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('family').providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.familyArguments
          ?.toSource(),
      '(0)',
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(family2Provider(id: 0))',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].listenable.node.toSource(),
      'family2Provider(id: 0)',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.node.toSource(),
      'family2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('family2')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.familyArguments
          ?.toSource(),
      '(id: 0)',
    );

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      'ref.watch(family3Provider(id: 0))',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].listenable.node.toSource(),
      'family3Provider(id: 0)',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.node.toSource(),
      'family3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family3')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.familyArguments
          ?.toSource(),
      '(id: 0)',
    );
  });

  testSource('Decodes provider.query ref.watch usages',
      runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'foo.g.dart';

extension on WidgetRef {
  void fn() {}
}

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

@Riverpod(keepAlive: true)
class Family extends _$Family {
  @override
  Future<int> build({required int id}) async => 0;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dep.select((e) => e));
    ref.watch(dep2Provider.select((e) => e));
    ref.watch(dep3Provider.select((e) => e));

    ref.watch(familyProvider(id: 42).notifier.select((e) => e).getter.method()[0]);


    return Container();
  }
}

extension<T> on T {
  T get getter => this;

  T method() => this;

  T operator[](Object key) => this;
}

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(dep);
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(4));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(dep.select((e) => e))',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].listenable.node.toSource(),
      'dep.select((e) => e)',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.node.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].listenable.provider?.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider.select((e) => e))',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].listenable.node.toSource(),
      'dep2Provider.select((e) => e)',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].listenable.provider?.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      'ref.watch(dep3Provider.select((e) => e))',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].listenable.node.toSource(),
      'dep3Provider.select((e) => e)',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].listenable.provider?.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );

    expect(
      result.widgetRefWatchInvocations[3].node.toSource(),
      'ref.watch(familyProvider(id: 42).notifier.select((e) => e).getter.method()[0])',
    );
    expect(result.widgetRefWatchInvocations[3].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[3].listenable.node.toSource(),
      'familyProvider(id: 42).notifier.select((e) => e).getter.method()[0]',
    );
    expect(
      result.widgetRefWatchInvocations[3].listenable.familyArguments
          ?.toSource(),
      '(id: 42)',
    );
    expect(
      result.widgetRefWatchInvocations[3].listenable.provider?.node.toSource(),
      'familyProvider',
    );
    expect(
      result.widgetRefWatchInvocations[3].listenable.provider?.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family')
            .providerElement,
      ),
    );
  });
}
