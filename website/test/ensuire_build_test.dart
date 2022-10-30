import 'package:build_verify/build_verify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ensure_build', () {
    expectBuildClean(
      packageRelativeDirectory: 'packages/riverpod_graph/test/integration/generated/golden',
    );
  });
}
