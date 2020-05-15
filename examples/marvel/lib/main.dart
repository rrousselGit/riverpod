import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'marvel.dart';

part 'main.freezed.dart';

@freezed
abstract class ReadMore<T> with _$ReadMore<T> {
  factory ReadMore(
    T data, {
    @required void Function() readMore,
  }) = _ReadMore<T>;
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final charactersProvider = StreamProvider((ref) async* {
  var totalCount = 0;
  var offset = 0;
  var allCharacters = const <Character>[];

  final repository = ref.dependOn(repositoryProvider).value;

  do {
    final res = await repository.fetchCharacters(offset: offset);

    final data = res.dataOrThrow;

    totalCount = data.totalCount;
    offset += data.characters.length;

    allCharacters = [
      ...allCharacters,
      ...data.characters,
    ];

    final completer = Completer<void>();

    yield ReadMore(allCharacters, readMore: () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;
  } while (allCharacters.length + 1 < totalCount);
});

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final characters = useProvider(charactersProvider);

    return characters.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(
            child: Text('$err'),
          ),
        );
      },
      data: (data) {
        return Scaffold(
          appBar: AppBar(title: Text('title')),
          body: ListView.builder(
            itemCount: data.data.length,
            itemBuilder: (context, index) {
              if (index + 1 == data.data.length) {
                data.readMore();
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(data.data[index].thumbnail.url),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(data.data[index].name),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
