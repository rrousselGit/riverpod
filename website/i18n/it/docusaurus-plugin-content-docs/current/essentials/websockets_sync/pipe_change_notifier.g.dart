// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
typedef MyListenableRef = Ref<Raw<ValueNotifier<int>>>;

/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
final class MyListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>,
    MyListenableRef> with $Provider<Raw<ValueNotifier<int>>, MyListenableRef> {
  /// A provider which creates a ValueNotifier and update its listeners
  /// whenever the value changes.
  const MyListenableProvider._(
      {Raw<ValueNotifier<int>> Function(
        MyListenableRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<ValueNotifier<int>> Function(
    MyListenableRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<ValueNotifier<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<ValueNotifier<int>>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  MyListenableProvider $copyWithCreate(
    Raw<ValueNotifier<int>> Function(
      MyListenableRef ref,
    ) create,
  ) {
    return MyListenableProvider._(create: create);
  }

  @override
  Raw<ValueNotifier<int>> create(MyListenableRef ref) {
    final _$cb = _createCb ?? myListenable;
    return _$cb(ref);
  }
}

String _$myListenableHash() => r'c80799a0224092668fca44187b98ccfcd2b33ae1';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
