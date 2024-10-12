import 'dart:async';
import 'dart:convert';

import 'package:riverpod/persist.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/common/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

// From Riverpod:
abstract class RiverpodOffline {}

// From you:

class MyAnnotation
    implements
        RiverpodOffline /* Necessary for Riverpod to know that offline is opted-in */ {
  const MyAnnotation({
    this.destroyKey,
  });

  final String? destroyKey;
}

class MyPersist<T> extends Persist<T> {
  MyPersist({this.sharedPreferences, this.adapter});

  final SharedPreferences? sharedPreferences;

  @override
  final MyAdapter<T>? adapter;
}

class MyAdapter<T> extends PersistAdapterWithPersist<T, MyPersist<T>> {
  const MyAdapter({required this.read, required this.write});

  final FutureOr<(T,)?> Function(
    SharedPreferences prefs,
    String key,
  ) read;
  final FutureOr<void> Function(
    SharedPreferences prefs,
    String key,
    Result<T> value,
  ) write;

  @override
  FutureOr<(T,)?> decode(
    Provider<T> provider,
    MyPersist<T>? providerPersist,
    MyPersist<T>? containerPersist,
  ) {
    final key = '$provider';
    final prefs = providerPersist?.sharedPreferences ??
        containerPersist?.sharedPreferences;
    if (prefs == null) {
      throw StateError('No SharedPreferences found');
    }

    return read(prefs, key);
  }

  @override
  FutureOr<void> encode(
    Provider<T> provider,
    MyPersist<T>? providerPersist,
    MyPersist<T>? containerPersist,
    T value,
  ) {
    final key = '$provider';
    final prefs = providerPersist?.sharedPreferences ??
        containerPersist?.sharedPreferences;
    if (prefs == null) {
      throw StateError('No SharedPreferences found');
    }

    return write(prefs, key, ResultData(value));
  }
}

// Users define:

void main() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    persist: MyPersist(sharedPreferences: sharedPrefs),
  );

  // Manual provider:
  final manualProvider = Provider(
    (ref) => 42,
    persist: MyPersist<int>(
      adapter: MyAdapter(
        read: (prefs, key) {
          final value = prefs.getInt(key);
          if (value == null) return null;
          return (value,);
        },
        write: (prefs, key, value) async {
          switch (value) {
            case ResultData<int>():
              await prefs.setInt(key, value.state);
            case ResultError<int>():
              await prefs.remove(key);
          }
        },
      ),
    ),
  );
}

class Model {
  Model();
  factory Model.fromJson(Map json) {}

  Map toJson() => {};
}

@riverpod
@MyAnnotation(destroyKey: 'My key')
Future<Model> model(Ref ref) async => Model();

class Generic<T extends num> {
  factory Generic.fromJson(Map json, T Function(Map) TfromJson) => Generic<T>();

  Map toJson(
    Map Function(T) TtoJson,
  ) =>
      {};
}

@riverpod
@MyAnnotation(destroyKey: 'My key')
Future<Generic<T>> generic<T extends num>(
  Ref<Generic<T>> ref,
  T Function(Map) TfromJson,
) async =>
    Generic<T>();

// You generate

class _$ModelPersistAdapter extends MyAdapter<Model> {
  const _$ModelPersistAdapter()
      : super(
          read: _readModel,
          write: _writeModel,
        );

  static FutureOr<(Model,)?> _readModel(
      SharedPreferences prefs, String key) async {
    final value = prefs.getString(key);
    if (value == null) return null;
    final json = jsonDecode(value) as Map;
    return (Model.fromJson(json),);
  }

  static FutureOr<void> _writeModel(
    SharedPreferences prefs,
    String key,
    Result<Model> value,
  ) async {
    switch (value) {
      case ResultData<Model>(:final state):
        await prefs.setString(key, jsonEncode(state.toJson()));
      case ResultError<Model>():
        await prefs.remove(key);
    }
  }
}

class _$GenericPersistAdapter<T extends num> extends MyAdapter<Generic<T>> {
  _$GenericPersistAdapter()
      : super(
          read: (prefs, key) async {
            final value = prefs.getString(key);
            if (value == null) return null;
            final json = jsonDecode(value) as Map;

            provider.TfromJson(json);

            return (
              Generic<T>.fromJson(
                json,
              ),
            );
          },
          write: (prefs, key, value) async {
            switch (value) {
              case ResultData<Generic<T>>(:final state):
                await prefs.setString(key, jsonEncode(state.toJson()));
              case ResultError<Generic<T>>():
                await prefs.remove(key);
            }
          },
        );
}
