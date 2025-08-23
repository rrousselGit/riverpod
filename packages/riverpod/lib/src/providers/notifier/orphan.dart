part of '../notifier.dart';

/// {@template riverpod.notifier}
/// A class which exposes a state that can change over time.
///
/// For example, [Notifier] can be used to implement a counter by doing:
///
/// ```dart
/// final counterProvider = NotifierProvider<Counter, int>(Counter.new);
///
/// class Counter extends Notifier<int> {
///   @override
///   int build() {
///     // Inside "build", we return the initial state of the counter.
///     return 0;
///   }
///
///   void increment() {
///     state++;
///   }
/// }
/// ```
///
/// We can then listen to the counter inside widgets by doing:
///
/// ```dart
/// Consumer(
///   builder: (context, ref) {
///     return Text('count: ${ref.watch(counterProvider)}');
///   },
/// )
/// ```
///
/// And finally, we can update the counter by doing:
///
/// ```dart
/// Consumer(
///   builder: (context, ref) {
///     return ElevatedButton(
///       onTap: () => ref.read(counterProvider.notifier).increment(),
///       child: const Text('increment'),
///     );
///   },
/// )
/// ```
///
/// The state of [Notifier] is expected to be initialized synchronously.
/// For asynchronous initializations, see [AsyncNotifier].
/// {@endtemplate}
/// {@category Notifiers}
abstract class Notifier<ValueT> extends $Notifier<ValueT> {
  /// {@template riverpod.notifier.build}
  /// Initialize a [Notifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [Notifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [Notifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws, reading this provider will rethrow the error.
  /// {@endtemplate}
  @visibleForOverriding
  ValueT build();

  @mustCallSuper
  @override
  void runBuild() {
    final created = build();
    requireElement().handleValue(ref, created);
  }
}

/// {@template riverpod.notifier_provider}
/// A provider that exposes a synchronous [Notifier].
///
/// [NotifierProvider] can be considered as a mutable [Provider].
/// {@endtemplate}
/// {@category Providers}
final class NotifierProvider<NotifierT extends Notifier<ValueT>, ValueT>
    extends $NotifierProvider<NotifierT, ValueT>
    with LegacyProviderMixin<ValueT> {
  /// {@macro riverpod.notifier_provider}
  NotifierProvider(
    this._createNotifier, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
         $allTransitiveDependencies: computeAllTransitiveDependencies(
           dependencies,
         ),
         from: null,
         argument: null,
       );

  /// An implementation detail of Riverpod
  /// @nodoc
  @internal
  NotifierProvider.internal(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = NotifierProviderFamilyBuilder();

  final NotifierT Function() _createNotifier;

  /// @nodoc
  @internal
  @override
  NotifierT create() => _createNotifier();
}
