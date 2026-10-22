import 'package:analysis_server_plugin/registry.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:internal_lint/main.dart';
import 'package:test/test.dart';

void main() {
  test('registers every rule', () {
    final registry = _Registry();
    plugin.register(registry);

    expect(plugin.name, 'internal_lint');
    expect(registry.warningRules.map((rule) => rule.name), [
      'generic_name',
      'rule_visitor',
      'avoid_sub_read',
      'avoid_legacy_api',
      'show_all_public_api',
    ]);
  });
}

class _Registry implements PluginRegistry {
  final warningRules = <AbstractAnalysisRule>[];

  @override
  void registerWarningRule(AbstractAnalysisRule rule) => warningRules.add(rule);

  @override
  void noSuchMethod(Invocation invocation) {}
}
