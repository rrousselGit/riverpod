///  A pure Dart script that fetches the list of comics from https://developer.marvel.com/
///
///  The process is split into two objects:
///
///  - [Configuration], which stores the API keys of a marvel account.
///    This object is loaded asynchronously by reading a JSON file.
///  - [Repository], a utility that depends on [Configuration] to
///    connect to https://developer.marvel.com/ and request the comics.
///
///  Both [Repository] and [Configuration] are created using `riverpod`.
///
///  This showcases how to use `riverpod` without Flutter.
///  It also shows how a provider can depend on another provider asynchronously loaded.
library main;

import 'dart:convert';
import 'dart:io';

import 'package:riverpod/riverpod.dart';

import 'models.dart';

/// A Provider that reads a json file and decodes it into a [Configuration].
final configurationProvider = FutureProvider<Configuration>((_) async {
  final file = await File.fromUri(Uri.file('configuration.json')) //
      .readAsString();
  final map = json.decode(file) as Map<String, Object?>;

  return Configuration.fromJson(map);
});

/// Creates a [Repository] from [configurationProvider].
///
/// This will correctly wait until the configurations are available.
final repositoryProvider = FutureProvider<Repository>((ref) async {
  /// Reads the configurations from [configurationProvider]. This is type-safe.
  final configs = await ref.watch(configurationProvider.future);

  final repository = Repository(configs);
  // Releases the resources when the provider is destroyed.
  // This will stop pending HTTP requests.
  ref.onDispose(repository.dispose);

  return repository;
});

Future<void> main() async {
  // Where the state of our providers will be stored.
  // Avoid making this a global variable, for testability purposes.
  // If you are using Flutter, you do not need this.
  final container = ProviderContainer();

  /// Obtains the [Repository]. This will implicitly load [Configuration] too.
  final repository = await container.read(repositoryProvider.future);

  final comics = await repository.fetchComics();
  for (final comic in comics) {
    print(comic.title);
  }

  /// Disposes the providers associated with [container].
  container.dispose();
}
