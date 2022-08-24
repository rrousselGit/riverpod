import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  test('goldens', () async {
    final result = await Process.run(
      'flutter',
      ['pub', 'run', 'custom_lint'],
      stdoutEncoding: utf8,
    );

    expect(result.stdout, '''
  test/goldens/avoid_dynamic_provider.dart:10:9 • Providers should be either top level variables or static properties • riverpod_avoid_dynamic_provider
  test/goldens/avoid_dynamic_provider.dart:14:9 • Providers should be either top level variables or static properties • riverpod_avoid_dynamic_provider
  test/goldens/avoid_dynamic_provider.dart:15:9 • Providers should be either top level variables or static properties • riverpod_avoid_dynamic_provider
  test/goldens/avoid_dynamic_provider.dart:16:9 • Providers should be either top level variables or static properties • riverpod_avoid_dynamic_provider
  test/goldens/dependencies.dart:20:4 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/dependencies.dart:25:22 • This provider specifies that it depends on "b" yet it never uses that provider. • riverpod_unused_dependency
  test/goldens/dependencies.dart:42:7 • This provider does not specify `dependencies`, yet depends on "c" which did specify its dependencies. • riverpod_unspecified_dependencies
  test/goldens/dependencies.dart:64:4 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/dependencies.dart:82:19 • This provider specifies that it depends on "a" yet it never uses that provider. • riverpod_unused_dependency
  test/goldens/dependencies.dart:93:4 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/dependencies.dart:110:48 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/dependencies.dart:122:60 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/dependencies.dart:127:4 • This provider depends on "a" yet "a" isn't listed in the dependencies. • riverpod_missing_dependency
  test/goldens/final_provider.dart:5:14 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/final_provider.dart:6:51 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/final_provider.dart:11:5 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/final_provider.dart:13:5 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/final_provider.dart:15:42 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/mutate_in_create.dart:7:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:17:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:21:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:22:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:23:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:50:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:51:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:52:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:54:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:55:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/read_vs_watch.dart:10:3 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:13:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:18:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:26:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:29:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:34:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:45:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:48:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:53:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:65:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:69:7 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:75:9 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:85:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:94:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:98:7 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:104:9 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:114:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:128:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/ref_escape_scope.dart:7:12 • Ref escaped the scope via a function or return expression. • riverpod_ref_escape_scope
  test/goldens/ref_escape_scope.dart:33:32 • Ref escaped its scope to another widget. • riverpod_ref_escape_scope
  test/goldens/ref_escape_scope.dart:42:32 • Ref escaped its scope to another widget. • riverpod_ref_escape_scope
''');
  });
}
