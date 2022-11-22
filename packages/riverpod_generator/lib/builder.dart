import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builder_configs.dart';
import 'src/riverpod_generator.dart';

/// Builds generators for `build_runner` to run
Builder riverpodBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [RiverpodGenerator(BuilderConfigs.fromJson(options.config))],
    'riverpod',
  );
}
