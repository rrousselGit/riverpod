import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_class_future.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  Future<String> build() async {
    return Future.value('foo');
  }

  // Aggiungere i metodi per mutare lo stato
}
