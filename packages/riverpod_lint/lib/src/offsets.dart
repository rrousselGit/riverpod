import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

import 'node.dart';

bool isOverlappingClassHeading(
  ClassDeclaration node, {
  required int selectionOffset,
}) {
  // Select from "class" to the opening bracket
  final classHeading = range.startEnd(node.classKeyword, node.headingEndToken);

  if (!classHeading.contains(selectionOffset)) return false;

  return true;
}
