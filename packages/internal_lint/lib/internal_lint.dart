import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/show_all.dart';

/// The plugin entry point.
PluginBase createPlugin() => _InternalLints();

class _InternalLints extends PluginBase {
  @override
  List<DartLintRule> getLintRules(CustomLintConfigs configs) => [
        const ShowAll(),
      ];
}
