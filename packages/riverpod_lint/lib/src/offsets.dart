import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

extension ProducerOffset on CorrectionProducer {
  bool isOverlappingClassHeading(ClassDeclaration node) {
    // Select from "class" to the opening bracket
    final classHeading = range.startEnd(
      node.classKeyword,
      node.leftBracket,
    );

    if (!classHeading.contains(selectionOffset)) return false;

    return true;
  }
}
