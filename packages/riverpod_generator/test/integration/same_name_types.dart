// Regression test for https://github.com/rrousselGit/riverpod/issues/4372
// Two unrelated classes share a name, and one of them is also visible without
// a prefix. If the generated code used the wrong prefix (or none) for either,
// it would not compile.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'same_name_types/a.dart' as a;
import 'same_name_types/a_export.dart';
import 'same_name_types/b.dart' as b;

part 'same_name_types.g.dart';

@riverpod
b.Model functional(Ref ref, b.Model model, {a.Model? other}) => model;

@riverpod
Future<List<b.Model>> generic(Ref ref, Map<a.Model, b.Model> models) async {
  return models.values.toList();
}

@riverpod
Model unprefixed(Ref ref, Model model) => model;

@riverpod
class ClassBased extends _$ClassBased {
  @override
  a.Model build(a.Model model, {required b.Model other}) => model;
}
