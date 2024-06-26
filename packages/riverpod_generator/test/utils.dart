import 'package:test/test.dart';

Matcher completionOr(Object? matcher) {
  return anyOf(
    matcher,
    completion(matcher),
  );
}
