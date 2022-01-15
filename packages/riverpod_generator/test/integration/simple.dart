import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'simple.g.dart';

@provider
String _publicProvider(PublicProviderRef ref) {
  return 'Hello world';
}

@provider
String __privateProvider(_PrivateProviderRef ref) {
  return 'Hello world';
}
