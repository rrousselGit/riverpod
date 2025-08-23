import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@riverpod
Future<List<ObjT>> generic<ObjT extends num>(Ref ref) async {
  return <ObjT>[];
}

@riverpod
class GenericClass<ObjT extends num> extends _$GenericClass<ObjT> {
  @override
  Future<List<ObjT>> build() async {
    return <ObjT>[];
  }
}

@riverpod
class GenericArg<ObjT extends num> extends _$GenericArg<ObjT> {
  @override
  Future<String> build(ObjT arg) async => 'Hello $ObjT $arg';
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
typedef Regression3490Cb<ModelT, SortT, CursorT> =
    Future<(int, CursorT)> Function({
      Map<String, dynamic> filters,
      SortT? sort,
      CursorT? cursor,
    });

@riverpod
class Regression3490<ModelT, SortT, CursorT>
    extends _$Regression3490<ModelT, SortT, CursorT> {
  @override
  void build({
    required String type,
    required Regression3490Cb<ModelT, SortT, CursorT> getData,
    String? parentId,
  }) {}
}
