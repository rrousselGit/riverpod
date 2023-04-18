// DO NOT MOVE/RENAME

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import '../riverpod_annotation.dart';

/// {@template riverpod_annotation.provider}
/// An annotation placed on classes or functions.
///
/// This tells riverpod_generator to generate a provider out of the annotated.
///
/// By default, Riverpod will convert [Future]s and [Stream]s into [AsyncValue]s.
/// If this is undesired, you can use [Raw] to have Riverpod forcibly return
/// the raw [Future]/[Stream] instead.
/// element.
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.function})
@sealed
class Riverpod {
  /// {@macro riverpod_annotation.provider}
  const Riverpod({
    this.keepAlive = false,
    this.dependencies,
  });

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  /// The list of dependencies of a provider.
  ///
  /// Values passed to the list of dependency should be the classes/functions
  /// annotated with `@riverpod`; not the provider.
  final List<Object>? dependencies;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();

/// An annotation used to help the linter find the user-defined element from
/// the generated provider.
///
/// DO NOT USE
class ProviderFor {
  /// An annotation used to help the linter find the user-defined element from
  /// the generated provider.
  // Put the annotation on the constructor to avoid the linter from complaining
  // about the annotation being exported; while preventing the user from using it.
  @internal
  const ProviderFor(this.value)
      : assert(
          value is Function || value is Type,
          '$value is not a class/function',
        );

  /// The code annotated by `@riverpod`
  final Object value;
}

/// {@template riverpod_annotation.raw}
/// An annotation for marking a value type as "should not be handled
/// by Riverpod".
///
/// This is a type-alias to [T], and has no runtime effect. It is only used
/// as metadata for the code-generator/linter.
///
/// This serves two purposes:
/// - It enables a provider to return a [Future]/[Stream] without
///   having the provider converting it into an [AsyncValue].
///   ```dart
///   @riverpod
///   Raw<Future<int>> myProvider(...) async => ...;
///   ...
///   // returns a Future<int> instead of AsyncValue<int>
///   Future<int> value = ref.watch(myProvider);
///   ```
///
/// - It can silence the linter when a provider returns a value that
///   is otherwise not supported, such as Flutter's `ChangeNotifier`:
///   ```dart
///   // Will not trigger the "unsupported return type" lint
///   @riverpod
///   Raw<MyChangeNotifier> myProvider(...) => MyChangeNotifier();
///   ```
///
/// The typedef can be used at various places within the return type declaration.
///
/// For example, a valid return type is `Future<Raw<ChangeNotifier>>`.
/// This way, Riverpod will convert the [Future] into an [AsyncValue], and
/// the usage of `ChangeNotifier` will not trigger the linter:
///
/// ```dart
/// @riverpod
/// Future<Raw<ChangeNotifier>> myProvider(...) async => ...;
/// ...
/// AsyncValue<ChangeNotifier> value = ref.watch(myProvider);
/// ```
///
/// {@endtemplate}
typedef Raw<T> = T;
