// ignore: invalid_export_of_internal_element, those are marked with internal. We export them for backward compatibility
export 'src/riverpod_internals_export.dart';
export 'src/riverpod_without_legacy.dart';

// ignore: directives_ordering, https://github.com/dart-lang/sdk/issues/60427
@Deprecated(
  'This is old API. Use `package:riverpod/legacy.dart` if you want to keep using it.',
)
export 'legacy.dart';
