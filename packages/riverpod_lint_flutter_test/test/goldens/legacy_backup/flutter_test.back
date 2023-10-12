import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  test('goldens', timeout: Timeout(Duration(seconds: 60)), () async {
    final result = await Process.run(
      'flutter',
      ['pub', 'run', 'custom_lint'],
      stdoutEncoding: utf8,
    );

    expect(result.stdout, '''
  test/goldens/auto_dispose_read.dart:11:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/auto_dispose_read.dart:11:5 • Avoid using ref.read on an autoDispose provider • riverpod_avoid_read_auto_dispose
  test/goldens/auto_dispose_read.dart:20:3 • Avoid using ref.read on an autoDispose provider • riverpod_avoid_read_auto_dispose
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
  test/goldens/global_providers.dart:3:7 • This container is global • riverpod_global_container
  test/goldens/global_providers.dart:4:7 • This container is global • riverpod_global_container
  test/goldens/global_providers.dart:4:41 • This container is global • riverpod_global_container
  test/goldens/mutate_in_create.dart:10:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:11:3 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:21:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:25:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:26:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:27:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:54:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:55:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:56:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:57:5 • Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed • riverpod_no_ref_after_async
  test/goldens/mutate_in_create.dart:58:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:58:5 • Do not use ref after async gaps in flutter widgets. • riverpod_no_ref_after_async
  test/goldens/mutate_in_create.dart:59:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:60:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:108:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:112:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:113:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:114:5 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:115:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:116:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:140:3 • Do not mutate a provider synchronously, a function was called which mutates a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:154:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:155:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:156:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:168:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:169:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:170:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:180:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:181:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:182:3 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:195:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:196:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:197:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:210:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:211:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.dart:212:5 • Do not mutate a provider synchronously • riverpod_no_mutate_sync
  test/goldens/mutate_in_create.g.dart:92:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/mutate_in_create.g.dart:195:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/mutate_in_create.g.dart:291:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/mutate_in_create.g.dart:377:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/read_vs_watch.dart:12:3 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:20:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:28:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:36:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:47:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:55:7 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:67:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:71:7 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:77:9 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:87:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:96:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:100:7 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:106:9 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:116:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:130:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.dart:137:3 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:146:5 • Avoid using ref.read inside the build method of widgets/providers. • riverpod_avoid_read_inside_build
  test/goldens/read_vs_watch.dart:153:5 • Avoid using ref.watch outside the build method of widgets/providers. • riverpod_avoid_watch_outside_build
  test/goldens/read_vs_watch.g.dart:92:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/read_vs_watch.g.dart:188:12 • Providers should always be declared as final • riverpod_final_provider
  test/goldens/ref_escape_scope.dart:7:12 • Ref escaped the scope via a function or return expression. • riverpod_ref_escape_scope
  test/goldens/ref_escape_scope.dart:37:32 • Ref escaped its scope to another widget. • riverpod_ref_escape_scope
  test/goldens/ref_escape_scope.dart:46:32 • Ref escaped its scope to another widget. • riverpod_ref_escape_scope
  test/goldens/use_ref_before_async_gaps.dart:48:11 • Do not use ref after async gaps in flutter widgets. • riverpod_no_ref_after_async
  test/goldens/use_ref_before_async_gaps.dart:51:9 • Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed • riverpod_no_ref_after_async
  test/goldens/use_ref_before_async_gaps.dart:53:9 • Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed • riverpod_no_ref_after_async
  test/goldens/use_ref_before_async_gaps.dart:55:9 • Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed • riverpod_no_ref_after_async
  test/goldens/use_ref_before_async_gaps.dart:57:15 • Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed • riverpod_no_ref_after_async
  test/goldens/use_ref_before_async_gaps.dart:59:9 • Do not use ref after async gaps in flutter widgets. • riverpod_no_ref_after_async
''');
  }, skip: 'TODO flaky');
}
