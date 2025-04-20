import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retry.g.dart';

@Riverpod(retry: myRetry)
String a(Ref ref) => throw UnimplementedError();

Duration? myRetry(int retryCount, Object error) => null;
Duration? myRetry2(int retryCount, Object error) => null;

@Riverpod(retry: myRetry2)
String b(Ref ref, int arg) => throw UnimplementedError();
