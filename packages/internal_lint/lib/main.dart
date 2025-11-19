import 'dart:async';
import 'dart:io';

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/lints/avoid_sub_read.dart';
import 'src/lints/generic_name.dart';
import 'src/lints/show_all.dart';
import 'src/lints/visitors.dart';

/// Enables internal lints
final plugin = _Plugin();

void log(Object obj) {
  File('/Users/remirousselet/dev/rrousselGit/riverpod/log.txt')
    ..createSync(recursive: true)
    ..writeAsStringSync('$obj\n', mode: FileMode.append);
}

class _Plugin extends Plugin {
  @override
  String get name => 'internal_lint';

  @override
  FutureOr<void> register(PluginRegistry registry) {
    registry.registerWarningRule(GenericName());

    registry.registerWarningRule(RuleVisitor());

    registry.registerWarningRule(AvoidSubRead());

    registry.registerWarningRule(ShowAll());
    registry.registerFixForRule(ShowAll.code, ShowAllFix.new);
  }
}
