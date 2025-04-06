import 'package:test/test.dart';
import 'integration/auto_dispose.dart';

void main() {
  test('Respects keepAlive parameter', () {
    expect(keepAliveProvider.isAutoDispose, isFalse);
    expect(notKeepAliveProvider.isAutoDispose, isTrue);
    expect(defaultKeepAliveProvider.isAutoDispose, isTrue);
  });
}
