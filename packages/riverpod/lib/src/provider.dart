import 'package:meta/meta.dart';

import 'builders.dart';
import 'framework.dart';
import 'state_notifier_provider.dart' show StateNotifierProvider;
import 'stream_provider.dart' show StreamProvider;

part 'provider/auto_dispose.dart';
part 'provider/base.dart';

abstract class _ProviderBase<State> extends ProviderBase<State>
    with OverrideWithValueMixin<State> {
  _ProviderBase({
    required this.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  State _create(covariant ProviderElement<State> ref);
}
