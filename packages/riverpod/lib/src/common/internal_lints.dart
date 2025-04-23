import 'package:meta/meta.dart';

@internal
class Public {
  const Public.inLibrary(this.library, {this.packageName});

  /// The name of the library which should show this public API.
  final String library;
  final String? packageName;
}

@internal
class AllOf {
  const AllOf(this.public);
  final List<Public> public;
}

@internal
const publicInCodegen = Public.inLibrary(
  'riverpod_annotation',
  packageName: 'riverpod_annotation',
);

@internal
const publicInMisc = Public.inLibrary('misc');

@internal
const publicInLegacy = Public.inLibrary('legacy');

@internal
const publicInPersist = Public.inLibrary('persist');

@internal
const publicInRiverpodAndCodegen = AllOf([
  Public.inLibrary('riverpod', packageName: 'riverpod'),
  Public.inLibrary('flutter_riverpod', packageName: 'flutter_riverpod'),
  Public.inLibrary('hooks_riverpod', packageName: 'hooks_riverpod'),
  Public.inLibrary('riverpod_annotation', packageName: 'riverpod_annotation'),
]);
