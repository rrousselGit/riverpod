// ignore_for_file: avoid_print

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';

void printDebugInfo(ResolvedCorrectionProducer producer) {
  final line = producer.unit.declaredFragment!.source.contents.data
      .substring(
        producer.utils.getLineThis(producer.selectionOffset),
        producer.utils.getLineNext(producer.selectionOffset),
      )
      .replaceAll('\n', '');
  final lineNumber = producer.unit.declaredFragment!.lineInfo
      .getLocation(producer.selectionOffset)
      .lineNumber;

  print(
    '$lineNumber `$line` // ${producer.token} // ${producer.node.runtimeType}',
  );
}
