import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avoid_generated_classes_as_return_type.freezed.dart';
part 'avoid_generated_classes_as_return_type.g.dart';

@freezed
class GeneratedClass with _$GeneratedClass {
  const factory GeneratedClass() = _GeneratedClass;
}

@riverpod
// expect_lint: avoid_generated_classes_as_return_type
_GeneratedClass fn(FnRef ref) => _GeneratedClass();

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  // expect_lint: avoid_generated_classes_as_return_type
  _GeneratedClass build() => _GeneratedClass();
}
