import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/dependencies.dart';

void main() {
  test('Supports specifying dependencies', () {
    expect(depProvider.dependencies, null);
    expect(dep2Provider.dependencies, null);
    expect(familyProvider.dependencies, null);
    expect(family2Provider.dependencies, null);

    expect(
      providerProvider.dependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider2Provider.dependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider3Provider.dependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider4Provider.dependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );

    expect(transitiveDependenciesProvider.dependencies, [providerProvider]);

    expect(
      emptyDependenciesFunctionalProvider.dependencies,
      same(const <ProviderOrFamily>[]),
    );

    expect(
      emptyDependenciesClassBasedProvider.dependencies,
      same(const <ProviderOrFamily>[]),
    );
  });

  test('Generates transitive dependencies', () {
    expect(depProvider.allTransitiveDependencies, null);
    expect(dep2Provider.allTransitiveDependencies, null);
    expect(familyProvider.allTransitiveDependencies, null);
    expect(family2Provider.allTransitiveDependencies, null);

    expect(
      providerProvider.allTransitiveDependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider2Provider.allTransitiveDependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider3Provider.allTransitiveDependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );
    expect(
      provider4Provider.allTransitiveDependencies,
      [depProvider, familyProvider, dep2Provider, family2Provider],
    );

    expect(
      transitiveDependenciesProvider.allTransitiveDependencies,
      [
        providerProvider,
        depProvider,
        familyProvider,
        dep2Provider,
        family2Provider,
      ],
    );

    expect(
      emptyDependenciesFunctionalProvider.allTransitiveDependencies,
      same(const <ProviderOrFamily>{}),
    );

    expect(
      emptyDependenciesClassBasedProvider.allTransitiveDependencies,
      same(const <ProviderOrFamily>{}),
    );
  });

  test('Caches dependencies', () {
    expect(
      providerProvider.dependencies,
      same(providerProvider.dependencies),
    );
    expect(
      provider2Provider.dependencies,
      same(provider2Provider.dependencies),
    );
    expect(
      provider3Provider.dependencies,
      same(provider3Provider.dependencies),
    );
    expect(
      provider4Provider.dependencies,
      same(provider4Provider.dependencies),
    );
    expect(
      transitiveDependenciesProvider.dependencies,
      same(transitiveDependenciesProvider.dependencies),
    );
    expect(
      smallTransitiveDependencyCountProvider.dependencies,
      same(smallTransitiveDependencyCountProvider.dependencies),
    );
    expect(
      emptyDependenciesFunctionalProvider.dependencies,
      same(emptyDependenciesFunctionalProvider.dependencies),
    );
    expect(
      emptyDependenciesClassBasedProvider.dependencies,
      same(emptyDependenciesClassBasedProvider.dependencies),
    );

    expect(
      provider3Provider.allTransitiveDependencies,
      same(provider3Provider.allTransitiveDependencies),
    );
    expect(
      provider4Provider.allTransitiveDependencies,
      same(provider4Provider.allTransitiveDependencies),
    );
    expect(
      transitiveDependenciesProvider.allTransitiveDependencies,
      same(transitiveDependenciesProvider.allTransitiveDependencies),
    );
    expect(
      smallTransitiveDependencyCountProvider.allTransitiveDependencies,
      same(smallTransitiveDependencyCountProvider.allTransitiveDependencies),
    );
  });
}
