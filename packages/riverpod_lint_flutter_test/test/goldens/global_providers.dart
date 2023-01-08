import 'package:hooks_riverpod/hooks_riverpod.dart';

// expect_lint: riverpod_global_container
final container1 = ProviderContainer();

// expect_lint: riverpod_global_container
final container2 = ProviderContainer(), container3 = ProviderContainer();
