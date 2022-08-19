// DO NOT MOVE/RENAME

import 'package:meta/meta_meta.dart';
import 'package:riverpod/riverpod.dart';

/// {@template riverpod_annotation.provider}
/// An annotation placed on classes or functions.
///
/// This tells riverpod_generator to generate a provider out of the annotated
/// element.
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.function})
class Riverpod {
  /// {@macro riverpod_annotation.provider}
  const Riverpod({
    this.keepAlive = false,
    this.disposeDelay,
    this.cacheTime,
  })  : assert(
          cacheTime == null || keepAlive == false,
          'Cannot set both keepAlive and cacheTime',
        ),
        assert(
          disposeDelay == null || keepAlive == false,
          'Cannot set both keepAlive and disposeDelay',
        );

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  /// The minimum amount of time before an `autoDispose` provider can be
  /// disposed if not listened after the last value change.
  ///
  /// If the provider rebuilds (such as when using `ref.watch` or `ref.refresh`)
  /// or emits a new value, the timer will be refreshed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [cacheTime].
  /// If no ancestor is found, fallbacks to 0.
  final int? cacheTime;

  /// The amount of time before a provider is disposed after its last listener is removed.
  ///
  /// If a new listener is added within that duration, the provider will not be disposed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [disposeDelay].
  /// If no ancestor is found, fallbacks to 0.
  final int? disposeDelay;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();
