import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'simple.g.dart';

@provider
@autoDispose
String _$label(_$LabelRef ref) {
  return 'Hello world';
}

class Label {}

class _$LabelRef {}

@provider
class _$Another with _$AnotherMixin {
  int init() {
    return 0;
  }

  @action
  void increment() => state + 1;
}

class Another {}

class _$AnotherRef {}

mixin _$AnotherMixin {
  _$AnotherRef get ref => throw UnimplementedError();
  int get state => throw UnimplementedError();
}
