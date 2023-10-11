import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Pubspec? parsePubspecIfExist(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;

  return Pubspec.parse(file.readAsStringSync());
}

void main() {
  final packageOffsetInPath =
      Directory.current.path.lastIndexOf('/hooks_riverpod');
  final baseDir = Directory.current.path
      .substring(0, packageOffsetInPath + '/hooks_riverpod'.length);

  final riverpodPubspec =
      parsePubspecIfExist('$baseDir/../riverpod/pubspec.yaml');
  final hooksRiverpodPubspec = parsePubspecIfExist('$baseDir/pubspec.yaml');
  final flutterRiverpodPubspec =
      parsePubspecIfExist('$baseDir/../flutter_riverpod/pubspec.yaml');
  final riverpodAnnotationPubspec =
      parsePubspecIfExist('$baseDir/../riverpod_annotation/pubspec.yaml');
  final riverpodGeneratorPubspec =
      parsePubspecIfExist('$baseDir/../riverpod_generator/pubspec.yaml');

  final allPubspecsWithRiverpodDependencies = <String, Pubspec?>{
    'flutter_riverpod': flutterRiverpodPubspec,
    'hooks_riverpod': hooksRiverpodPubspec,
    'riverpod_annotation': riverpodAnnotationPubspec,
    'riverpod_generator': riverpodGeneratorPubspec,
  };

  for (final pubspecEntry in allPubspecsWithRiverpodDependencies.entries) {
    if (riverpodPubspec == null) continue;
    if (flutterRiverpodPubspec == null) continue;
    if (hooksRiverpodPubspec == null) continue;
    if (riverpodAnnotationPubspec == null) continue;
    if (riverpodGeneratorPubspec == null) continue;

    final pubspec = pubspecEntry.value;
    if (pubspec == null) continue;

    void expectDependencyMatchesVersion(
      Dependency? dependency,
      Version version,
    ) {
      if (dependency is! HostedDependency) {
        // skip null and path dependencies
        return;
      }
      final actualVersion = dependency.version;

      expect(
        dependency.version,
        predicate<VersionConstraint>(
          (v) => v.allows(version),
          'has version compatible with $version',
        ),
      );

      // For version range such as ^1.2.3, the 1.2.3 version should be the latest
      if (actualVersion is VersionRange) {
        expect(
          actualVersion.min,
          version,
          reason: 'version range should use the latest version possible',
        );
      }
    }

    test('Pubspec ${pubspecEntry.key} is up-to-date with Riverpod', () {
      expectDependencyMatchesVersion(
        pubspec.dependencies['riverpod'],
        riverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.devDependencies['riverpod'],
        riverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.dependencyOverrides['riverpod'],
        riverpodPubspec.version!,
      );
    });

    test('Pubspec ${pubspecEntry.key} is up-to-date with flutter_riverpod', () {
      expectDependencyMatchesVersion(
        pubspec.dependencies['flutter_riverpod'],
        flutterRiverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.devDependencies['flutter_riverpod'],
        flutterRiverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.dependencyOverrides['flutter_riverpod'],
        flutterRiverpodPubspec.version!,
      );
    });

    test('Pubspec ${pubspecEntry.key} is up-to-date with hooks_riverpod', () {
      expectDependencyMatchesVersion(
        pubspec.dependencies['hooks_riverpod'],
        hooksRiverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.devDependencies['hooks_riverpod'],
        hooksRiverpodPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.dependencyOverrides['hooks_riverpod'],
        hooksRiverpodPubspec.version!,
      );
    });

    test('Pubspec ${pubspecEntry.key} is up-to-date with riverpod_generator',
        () {
      expectDependencyMatchesVersion(
        pubspec.dependencies['riverpod_generator'],
        riverpodGeneratorPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.devDependencies['riverpod_generator'],
        riverpodGeneratorPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.dependencyOverrides['riverpod_generator'],
        riverpodGeneratorPubspec.version!,
      );
    });

    test('Pubspec ${pubspecEntry.key} is up-to-date with riverpod_annotation',
        () {
      expectDependencyMatchesVersion(
        pubspec.dependencies['riverpod_annotation'],
        riverpodAnnotationPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.devDependencies['riverpod_annotation'],
        riverpodAnnotationPubspec.version!,
      );
      expectDependencyMatchesVersion(
        pubspec.dependencyOverrides['riverpod_annotation'],
        riverpodAnnotationPubspec.version!,
      );
    });
  }
}
