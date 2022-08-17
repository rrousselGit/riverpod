import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/src/internals.dart';

part 'sync.g.dart';

@provider
String _publicProvider(_PublicProviderRef ref) {
  return 'Hello world';
}

@provider
String _familyExample(
  _FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return 'Hello world';
}

@provider
String __privateProvider(__PrivateProviderRef ref) {
  return 'Hello world';
}

@provider
class _PublicClassProvider extends _$PublicClassProvider {
  @override
  String build() {
    return 'Hello world';
  }
}

@provider
class _ClassFamily extends _$ClassFamily {
  @override
  String build() {
    return 'Hello world';
  }
}

@provider
class __PrivateClassProvider extends _$PrivateClassProvider {
  @override
  String build() {
    return 'Hello world';
  }
}

void main() {
  final container = ProviderContainer();

  final x = container.read(PublicProvider);
  final y = container.read(PublicClassProvider);
}

Provider<String> FamilyExample(
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return _$FamilyExampleProvider(
    first,
    second: second,
    third: third,
    forth: forth,
    fifth: fifth,
  );
}


// ignore: subtype_of_sealed_class, invalid_use_of_internal_member
class _$FamilyExampleProvider extends Provider<String> {
  _$FamilyExampleProvider(
    this.first, {
    // required super.dependencies,
    // required super.name,
    // required super.argument,
    // required super.cacheTime,
    // required super.disposeDelay,
    this.second,
    required this.third,
    this.forth = true,
    this.fifth,
  }) : super(
          (ref) => _familyExample(
            ref,
            first,
            second: second,
            third: third,
            forth: forth,
            fifth: fifth,
          ),
          from: 
        );

  final int first;
  final String? second;
  final double third;
  final bool forth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is _$FamilyExampleProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.forth == forth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = SystemHash.combine(0, runtimeType.hashCode);
    hash = SystemHash.combine(hash, first.hashCode);
    hash = SystemHash.combine(hash, second.hashCode);
    hash = SystemHash.combine(hash, third.hashCode);
    hash = SystemHash.combine(hash, forth.hashCode);
    hash = SystemHash.combine(hash, fifth.hashCode);

    return SystemHash.finish(hash);
  }
}

@provider
class _MyNotifierFamily extends _$MyNotifierFamily {
  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return 'Hello world';
  }
}

abstract class _$MyNotifierFamily extends NotifierBase<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool forth;
  late final List<String>? fifth;

  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  });
}

NotifierProvider<_MyNotifierFamily, String> MyNotifierFamily(
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return _$MyNotifierFamilyProvider(
    first,
    second: second,
    third: third,
    forth: forth,
    fifth: fifth,
  );
}

// ignore: subtype_of_sealed_class, invalid_use_of_internal_member
class _$MyNotifierFamilyProvider
    extends NotifierProvider<_MyNotifierFamily, String> {
  _$MyNotifierFamilyProvider(
    this.first, {
    // super.dependencies,
    // super.name,
    // super.from,
    // super.argument,
    // super.cacheTime,
    // super.disposeDelay,
    required this.second,
    required this.third,
    required this.forth,
    required this.fifth,
  }) : super(
          () => _MyNotifierFamily()
            ..first = first
            ..second = second
            ..third = third
            ..forth = forth
            ..fifth = fifth,
        );

  final int first;
  final String? second;
  final double third;
  final bool forth;
  final List<String>? fifth;

  @override
  bool operator ==(Object other) {
    return other is _$MyNotifierFamilyProvider &&
        other.first == first &&
        other.second == second &&
        other.third == third &&
        other.forth == forth &&
        other.fifth == fifth;
  }

  @override
  int get hashCode {
    var hash = SystemHash.combine(0, runtimeType.hashCode);
    hash = SystemHash.combine(hash, first.hashCode);
    hash = SystemHash.combine(hash, second.hashCode);
    hash = SystemHash.combine(hash, third.hashCode);
    hash = SystemHash.combine(hash, forth.hashCode);
    hash = SystemHash.combine(hash, fifth.hashCode);

    return SystemHash.finish(hash);
  }

  String _runNotifierBuild(
    covariant _MyNotifierFamily notifier,
  ) {
    return notifier.build(
      first,
      second: second,
      third: third,
      forth: forth,
      fifth: fifth,
    );
  }
}

/// Copied from Dart SDK
class SystemHash {
  SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}
