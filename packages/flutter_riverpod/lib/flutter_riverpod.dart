// ignore: invalid_export_of_internal_element, those are marked with internal. We export them for backward compatibility
export 'package:riverpod/src/riverpod_internals_export.dart';
export 'package:riverpod/src/riverpod_without_legacy.dart';

@Deprecated(
  'This is old API. Use `package:riverpod/legacy.dart` if you want to keep using it.',
)
export './legacy.dart';
export 'src/riverpod_without_legacy.dart';
