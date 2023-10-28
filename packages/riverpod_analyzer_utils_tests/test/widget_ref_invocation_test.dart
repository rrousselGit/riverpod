import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

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
''', (resolver) async {
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
      result.widgetRefWatchInvocations.single.provider.familyArguments,
      null,
    );
    expect(
      result.widgetRefWatchInvocations.single.provider.node.toSource(),
      'gibberishProvider',
    );
    expect(
      result.widgetRefWatchInvocations.single.provider.provider?.toSource(),
      'gibberishProvider',
    );
    expect(
      result.widgetRefWatchInvocations.single.provider.providerElement,
      null,
    );
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      '..watch(dep)',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(result.widgetRefWatchInvocations[0].provider.node.toSource(), 'dep');
    expect(result.widgetRefWatchInvocations[0].provider.familyArguments, null);
    expect(
      result.widgetRefWatchInvocations[0].provider.provider?.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      '..watch(dep2Provider)',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].provider.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(result.widgetRefWatchInvocations[1].provider.familyArguments, null);

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      '..watch(dep3Provider)',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].provider.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(result.widgetRefWatchInvocations[2].provider.familyArguments, null);
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(dep)',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(result.widgetRefWatchInvocations[0].provider.node.toSource(), 'dep');
    expect(result.widgetRefWatchInvocations[0].provider.familyArguments, null);
    expect(
      result.widgetRefWatchInvocations[0].provider.provider?.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider)',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].provider.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(result.widgetRefWatchInvocations[1].provider.familyArguments, null);

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      'ref.watch(dep3Provider)',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].provider.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(result.widgetRefWatchInvocations[2].provider.familyArguments, null);
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final libraryResult = result.resolvedRiverpodLibraryResults.single;

    expect(libraryResult.unknownWidgetRefInvocations, hasLength(2));
    expect(
      result.widgetRefReadInvocations,
      libraryResult.unknownWidgetRefInvocations,
    );
    expect(result.widgetRefInvocations, result.widgetRefReadInvocations);

    expect(result.widgetRefReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.widgetRefReadInvocations[0].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefReadInvocations[1].node.toSource(),
      'ref.read(dep2)',
    );
    expect(result.widgetRefReadInvocations[1].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[1].provider.providerElement,
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
''', (resolver) async {
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
      result.widgetRefListenInvocations[0].provider.providerElement,
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
''', (resolver) async {
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
      result.widgetRefListenManualInvocations[0].provider.providerElement,
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
      result.widgetRefListenManualInvocations[1].provider.providerElement,
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
      result.widgetRefListenManualInvocations[2].provider.providerElement,
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefReadInvocations, hasLength(2));
    expect(result.widgetRefInvocations, result.widgetRefReadInvocations);

    expect(result.widgetRefReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.widgetRefReadInvocations[0].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefReadInvocations[1].node.toSource(),
      'ref.read(dep2)',
    );
    expect(result.widgetRefReadInvocations[1].function.toSource(), 'read');
    expect(
      result.widgetRefReadInvocations[1].provider.providerElement,
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final libraryResult = result.resolvedRiverpodLibraryResults.single;

    expect(libraryResult.unknownRefInvocations, isEmpty);
    expect(libraryResult.unknownWidgetRefInvocations, isEmpty);

    final providerRefInvocations =
        libraryResult.consumerWidgetDeclarations.single.widgetRefInvocations;

    expect(result.widgetRefWatchInvocations, hasLength(3));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);
    expect(result.widgetRefInvocations, providerRefInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(family(0))',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].provider.node.toSource(),
      'family(0)',
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.provider?.toSource(),
      'family',
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('family').providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.familyArguments?.toSource(),
      '(0)',
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(family2Provider(id: 0))',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].provider.node.toSource(),
      'family2Provider(id: 0)',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.provider?.toSource(),
      'family2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('family2')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.familyArguments?.toSource(),
      '(id: 0)',
    );

    expect(
      result.widgetRefWatchInvocations[2].node.toSource(),
      'ref.watch(family3Provider(id: 0))',
    );
    expect(result.widgetRefWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[2].provider.node.toSource(),
      'family3Provider(id: 0)',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.provider?.toSource(),
      'family3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family3')
            .providerElement,
      ),
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.familyArguments?.toSource(),
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.widgetRefWatchInvocations, hasLength(4));
    expect(result.widgetRefInvocations, result.widgetRefWatchInvocations);

    expect(
      result.widgetRefWatchInvocations[0].node.toSource(),
      'ref.watch(dep.select((e) => e))',
    );
    expect(result.widgetRefWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[0].provider.node.toSource(),
      'dep.select((e) => e)',
    );
    expect(result.widgetRefWatchInvocations[0].provider.familyArguments, null);
    expect(
      result.widgetRefWatchInvocations[0].provider.provider?.toSource(),
      'dep',
    );
    expect(
      result.widgetRefWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.widgetRefWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider.select((e) => e))',
    );
    expect(result.widgetRefWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.widgetRefWatchInvocations[1].provider.node.toSource(),
      'dep2Provider.select((e) => e)',
    );
    expect(result.widgetRefWatchInvocations[1].provider.familyArguments, null);
    expect(
      result.widgetRefWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.widgetRefWatchInvocations[1].provider.providerElement,
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
      result.widgetRefWatchInvocations[2].provider.node.toSource(),
      'dep3Provider.select((e) => e)',
    );
    expect(result.widgetRefWatchInvocations[2].provider.familyArguments, null);
    expect(
      result.widgetRefWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.widgetRefWatchInvocations[2].provider.providerElement,
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
      result.widgetRefWatchInvocations[3].provider.node.toSource(),
      'familyProvider(id: 42).notifier.select((e) => e).getter.method()[0]',
    );
    expect(
      result.widgetRefWatchInvocations[3].provider.familyArguments?.toSource(),
      '(id: 42)',
    );
    expect(
      result.widgetRefWatchInvocations[3].provider.provider?.toSource(),
      'familyProvider',
    );
    expect(
      result.widgetRefWatchInvocations[3].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family')
            .providerElement,
      ),
    );
  });
}
