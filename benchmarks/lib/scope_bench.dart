import 'package:riverpod/riverpod.dart';

import 'common.dart';

const int _kNumIterations = 5000;
const int _kNumWarmUp = 100;

/// Measures the cost of creating and disposing a scoped [ProviderContainer]
/// (i.e. what a `ProviderScope` with overrides pays) against roots of various
/// shapes.
///
/// A container created with an empty `overrides` list shares its parent's
/// pointer manager outright, so only scopes *with* overrides are measured here.
void main() {
  assert(
    false,
    "Don't run benchmarks in checked mode! Use 'dart run' or 'flutter run --release'.",
  );

  final printer = BenchmarkResultPrinter();
  final watch = Stopwatch();

  // The override that forces the scope to fork its parent's pointer table.
  final scopeTrigger = Provider<int>((ref) => 0, name: 'scopeTrigger');
  final overrides = [scopeTrigger.overrideWithValue(1)];

  void record(String name, String description, double Function() measure) {
    printer.addResult(
      description: description,
      value: measure(),
      unit: 'ns per iteration',
      name: name,
    );
  }

  double measureCreate(ProviderContainer root) {
    for (var i = 0; i < _kNumWarmUp; i++) {
      ProviderContainer(parent: root, overrides: overrides).dispose();
    }

    watch.reset();
    for (var i = 0; i < _kNumIterations; i++) {
      watch.start();
      final container = ProviderContainer(parent: root, overrides: overrides);
      watch.stop();
      container.dispose();
    }
    return watch.elapsedMicroseconds * 1000.0 / _kNumIterations;
  }

  double measureDispose(ProviderContainer root) {
    for (var i = 0; i < _kNumWarmUp; i++) {
      ProviderContainer(parent: root, overrides: overrides).dispose();
    }

    watch.reset();
    for (var i = 0; i < _kNumIterations; i++) {
      final container = ProviderContainer(parent: root, overrides: overrides);
      watch.start();
      container.dispose();
      watch.stop();
    }
    return watch.elapsedMicroseconds * 1000.0 / _kNumIterations;
  }

  // --- orphan providers -----------------------------------------------------
  // Declared without `dependencies`, so `$allTransitiveDependencies` is null,
  // `isTransitiveOverride` is false, and every one of them is copied by
  // `ProviderDirectory.from`.
  for (final count in [100, 1000]) {
    final root = buildRoot(orphanCount: count);
    record(
      'orphans_${count}_create',
      'create scope, $count orphans',
      () => measureCreate(root),
    );
    record(
      'orphans_${count}_dispose',
      'dispose scope, $count orphans',
      () => measureDispose(root),
    );
    root.dispose();
  }

  // --- families declared WITHOUT `dependencies` -----------------------------
  // `$allTransitiveDependencies == null`, so the directory is shared by
  // reference: only the map entry is copied, never the instances.
  for (final count in [100, 500]) {
    final root = buildRoot(familyCount: count, familyStyle: _FamilyStyle.none);
    record(
      'familiesNoDeps_${count}x10_create',
      'create scope, $count families x10 (no dependencies)',
      () => measureCreate(root),
    );
    root.dispose();
  }

  // --- families declared `dependencies: const []` ---------------------------
  // Survive the `.where` filter AND have a non-null `$allTransitiveDependencies`,
  // so each one gets a nested per-instance `ProviderDirectory.from`.
  for (final count in [100, 500]) {
    final root = buildRoot(familyCount: count, familyStyle: _FamilyStyle.empty);
    record(
      'familiesEmptyDeps_${count}x10_create',
      'create scope, $count families x10 (dependencies: const [])',
      () => measureCreate(root),
    );
    record(
      'familiesEmptyDeps_${count}x10_dispose',
      'dispose scope, $count families x10 (dependencies: const [])',
      () => measureDispose(root),
    );
    root.dispose();
  }

  // --- a realistic mixed app ------------------------------------------------
  final mixed = buildRoot(
    orphanCount: 500,
    familyCount: 200,
    familyStyle: _FamilyStyle.none,
    extraEmptyDepsFamilyCount: 100,
    extraScopedFamilyCount: 100,
  );
  record('mixed_create', 'create scope, mixed app', () => measureCreate(mixed));
  record(
    'mixed_dispose',
    'dispose scope, mixed app',
    () => measureDispose(mixed),
  );
  mixed.dispose();

  // --- the already-free baseline, as a floor to compare against -------------
  final empty = ProviderContainer();
  record(
    'emptyRoot_create',
    'create scope, empty root (floor)',
    () => measureCreate(empty),
  );
  record(
    'emptyRoot_dispose',
    'dispose scope, empty root (floor)',
    () => measureDispose(empty),
  );
  empty.dispose();

  printer.printToStdout();
}

enum _FamilyStyle { none, empty }

/// Builds and fully mounts a root container of a given shape.
ProviderContainer buildRoot({
  int orphanCount = 0,
  int familyCount = 0,
  _FamilyStyle familyStyle = _FamilyStyle.none,
  int instancesPerFamily = 10,
  int extraEmptyDepsFamilyCount = 0,
  int extraScopedFamilyCount = 0,
}) {
  final root = ProviderContainer();

  for (var i = 0; i < orphanCount; i++) {
    root.read(Provider<int>((ref) => i));
  }

  for (var i = 0; i < familyCount; i++) {
    final family = switch (familyStyle) {
      _FamilyStyle.none => Provider.family<int, int>((ref, id) => id),
      _FamilyStyle.empty => Provider.family<int, int>(
        (ref, id) => id,
        dependencies: const [],
      ),
    };
    for (var j = 0; j < instancesPerFamily; j++) {
      root.read(family(j));
    }
  }

  for (var i = 0; i < extraEmptyDepsFamilyCount; i++) {
    final family = Provider.family<int, int>(
      (ref, id) => id,
      dependencies: const [],
    );
    for (var j = 0; j < instancesPerFamily; j++) {
      root.read(family(j));
    }
  }

  // Non-empty `dependencies` and not overridden: dropped by the `.where` filter,
  // so these are free today. Included to keep the mixed shape honest.
  final dep = Provider<int>((ref) => 0, dependencies: const []);
  for (var i = 0; i < extraScopedFamilyCount; i++) {
    final family = Provider.family<int, int>(
      (ref, id) => id,
      dependencies: [dep],
    );
    for (var j = 0; j < instancesPerFamily; j++) {
      root.read(family(j));
    }
  }

  return root;
}
