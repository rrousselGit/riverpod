import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@riverpod
Future<List<T>> generic<T extends num>(Ref ref) async {
  return <T>[];
}

@riverpod
class GenericClass<T extends num> extends _$GenericClass<T> {
  @override
  Future<List<T>> build() async {
    return <T>[];
  }
}

@riverpod
FutureOr<String> public(Ref ref) {
  return 'Hello world';
}

const privateProvider = _privateProvider;

@riverpod
Future<String> _private(Ref ref) async {
  return 'Hello world';
}

@riverpod
FutureOr<String> familyOr(Ref ref, int first) {
  return '(first: $first)';
}

@riverpod
Future<String> family(
  Ref ref,
  int first, {
  String? second,
  required double third,
  bool fourth = true,
  List<String>? fifth,
}) async {
  return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
}

@riverpod
class PublicClass extends _$PublicClass {
  PublicClass([this.param]);

  final Object? param;

  @override
  FutureOr<String> build() {
    return 'Hello world';
  }
}

const privateClassProvider = _privateClassProvider;

//
@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

@riverpod
class FamilyOrClass extends _$FamilyOrClass {
  @override
  FutureOr<String> build(int first) {
    return '(first: $first)';
  }
}

@riverpod
class FamilyClass extends _$FamilyClass {
  FamilyClass([this.param]);

  final Object? param;

  @override
  Future<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) async {
    return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/3490
typedef Regression3490Cb<Model, Sort, Cursor> = Future<(int, Cursor)> Function({
  Map<String, dynamic> filters,
  Sort? sort,
  Cursor? cursor,
});

@riverpod
class Regression3490<Model, Sort, Cursor>
    extends _$Regression3490<Model, Sort, Cursor> {
  @override
  void build({
    required String type,
    required Regression3490Cb<Model, Sort, Cursor> getData,
    String? parentId,
  }) {}
}
