// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// 값이 변경될 때마다 ValueNotifier를 생성하고 리스너를 업데이트하는 provider입니다.
typedef MyListenableRef = Ref<ValueNotifier<int>>;

/// 값이 변경될 때마다 ValueNotifier를 생성하고 리스너를 업데이트하는 provider입니다.
@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

/// 값이 변경될 때마다 ValueNotifier를 생성하고 리스너를 업데이트하는 provider입니다.
final class MyListenableProvider extends $FunctionalProvider<
    ValueNotifier<int>,
    ValueNotifier<int>,
    MyListenableRef> with $Provider<ValueNotifier<int>, MyListenableRef> {
  /// 값이 변경될 때마다 ValueNotifier를 생성하고 리스너를 업데이트하는 provider입니다.
  const MyListenableProvider._(
      {ValueNotifier<int> Function(
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

  final ValueNotifier<int> Function(
    MyListenableRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ValueNotifier<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ValueNotifier<int>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<ValueNotifier<int>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  MyListenableProvider $copyWithCreate(
    ValueNotifier<int> Function(
      MyListenableRef ref,
    ) create,
  ) {
    return MyListenableProvider._(create: create);
  }

  @override
  ValueNotifier<int> create(MyListenableRef ref) {
    final _$cb = _createCb ?? myListenable;
    return _$cb(ref);
  }
}

String _$myListenableHash() => r'4cc07df2f47050c4aa761e5467f341ab6c312d09';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
