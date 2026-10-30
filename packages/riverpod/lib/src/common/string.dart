import 'package:meta/meta.dart';

@internal
extension StringX on String {
  String indent(int level) {
    final indent = '  ' * level;
    return split('\n').map((line) => '$indent$line').join('\n');
  }

  String indentAfterFirstLine(int level) {
    final indent = '  ' * level;
    return split('\n').join('\n$indent');
  }
}
