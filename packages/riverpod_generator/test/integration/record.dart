import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record.g.dart';

@riverpod
(int,) functional(Ref ref, (String,) arg) => (42,);

@riverpod
class Class extends _$Class {
  @override
  (String,) build((String,) arg) {
    return (arg.$1,);
  }
}

@riverpod
Future<(int,)> functionalAsync(Ref ref, (String,) arg) async => (42,);

@riverpod
class ClassAsync extends _$ClassAsync {
  @override
  Future<(String,)> build((String,) arg) async {
    return (arg.$1,);
  }
}

@riverpod
Stream<(int,)> functionalStream(Ref ref, (String,) arg) => Stream.value((42,));

@riverpod
class ClassStream extends _$ClassStream {
  @override
  Stream<(String,)> build((String,) arg) {
    return Stream.value((arg.$1,));
  }
}
