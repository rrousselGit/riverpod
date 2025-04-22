import 'package:meta/meta.dart';

@internal
class Public {
  const Public.inLibrary(this.library, {this.packageName});

  /// The name of the library which should show this public API.
  final String library;
  final String? packageName;
}

@internal
const publicInCodegen = Public.inLibrary(
  'riverpod_annotation',
  packageName: 'riverpod_annotation',
);

@internal
const publicInMisc = Public.inLibrary('misc');
