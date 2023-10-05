import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avoid_public_notifier_properties.g.dart';

class MyNotifier extends Notifier<int> {
  static int get staticPublicGetter => 0;

  static int staticPublicProperty = 0;

  int _privateProperty = 0;
  int get _privateGetter => _privateProperty;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  // Public setters are OK
  set publicSetter(int value) {
    _privateProperty = value;
  }

  // expect_lint: avoid_public_notifier_properties
  int publicProperty = 0;

  @protected
  int get protectedMember => 0;

  @visibleForTesting
  int get visibleForTestingMember => 0;

  @visibleForOverriding
  int get visibleForOverridingMember => 0;

  @override
  int build() => 0;

  void _privateMethod() {}

  // Public methods are OK
  void publicMethod() {
    _privateMethod();
  }
}

class MyAutoDisposeNotifier extends AutoDisposeNotifier<int> {
  int get _privateGetter => 0;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  @override
  int build() => 0;
}

class MyAutoDisposeFamilyNotifier extends AutoDisposeFamilyNotifier<int, int> {
  int get _privateGetter => 0;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  @override
  int build(int param) => 0;
}

class MyAsyncNotifier extends AsyncNotifier<int> {
  int get _privateGetter => 0;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  @override
  Future<int> build() async => 0;
}

class MyAutoDisposeAsyncNotifier extends AutoDisposeAsyncNotifier<int> {
  int get _privateGetter => 0;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  @override
  Future<int> build() async => 0;
}

class MyAutoDisposeFamilyAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<int, int> {
  int get _privateGetter => 0;

  // expect_lint: avoid_public_notifier_properties
  int get publicGetter => _privateGetter;

  @override
  Future<int> build(int param) async => 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/discussions/2642
@riverpod
class GeneratedNotifier extends _$GeneratedNotifier {
  @override
  int build(int param) {
    return 0;
  }
}
