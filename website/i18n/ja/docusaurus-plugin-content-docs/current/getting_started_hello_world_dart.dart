// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// 値（ここでは "Hello world"）を格納する「プロバイダ」を作成します。
// プロバイダを使うことで値のモックやオーバーライドが可能になります。
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // `ProviderContainer` に各プロバイダのステート（状態）・値が格納されていきます。
  final container = ProviderContainer();

  // `container` から `helloWorldProvider` の値を取得します。
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
