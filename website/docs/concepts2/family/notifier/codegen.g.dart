// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserNotifier)
final userProvider = UserNotifierFamily._();

final class UserNotifierProvider
    extends $AsyncNotifierProvider<UserNotifier, User> {
  UserNotifierProvider._({
    required UserNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userNotifierHash();

  @override
  String toString() {
    return r'userProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserNotifier create() => UserNotifier();

  @override
  bool operator ==(Object other) {
    return other is UserNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userNotifierHash() => r'4e3d6cd946a513daf5817745fab40a103e19436c';

final class UserNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          UserNotifier,
          AsyncValue<User>,
          User,
          FutureOr<User>,
          String
        > {
  UserNotifierFamily._()
    : super(
        retry: null,
        name: r'userProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserNotifierProvider call(String id) =>
      UserNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'userProvider';
}

abstract class _$UserNotifier extends $AsyncNotifier<User> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<User> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User>, User>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User>, User>,
              AsyncValue<User>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
