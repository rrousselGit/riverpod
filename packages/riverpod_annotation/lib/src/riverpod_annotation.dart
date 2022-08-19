// DO NOT MOVE/RENAME

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

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
  });

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  final int? cacheTime;
  final int? disposeDelay;
}

// /// The implementation of the [Riverpod] annotation.
// ///
// /// The annotation is implementated in two clases to:
// /// - differentiate `Riverpod(cacheTime: null)` from `Riverpod()`
// /// - ensure [cacheTime]/[disposeDelay] are typed as `Duration?`
// @internal
// class RiverpodImpl implements Riverpod {
//   /// {@macro riverpod_annotation.provider}
//   const RiverpodImpl({
//     this.keepAlive = false,
//     this.cacheTime = const Object(),
//     this.disposeDelay = const Object(),
//   })  : assert(
//           keepAlive == false || cacheTime == const Object(),
//           'Cannot set keepAlive and cacheTime at the same time',
//         ),
//         assert(
//           keepAlive == false || disposeDelay == const Object(),
//           'Cannot set keepAlive and disposeDelay at the same time',
//         );

//   /// Whether the state of the provider should be maintained if it is no-longer used.
//   ///
//   /// Defaults to false.
//   @override
//   final bool keepAlive;

//   @override
//   final Object? cacheTime;

//   @override
//   final Object? disposeDelay;
// }

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();
