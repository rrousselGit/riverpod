import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'simple.g.dart';

@atom
@autoDispose
String _$label(LabelRef ref) {
  return 'Hello world';
}

class Label {}

class LabelRef {}
