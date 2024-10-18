<p align="center">
<a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>

<p align="center">
<a href="https://www.netlify.com">
  <img src="https://www.netlify.com/img/global/badges/netlify-color-accent.svg" alt="Deploys by Netlify" />
</a>
</p>

<p align="center">
<img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

</p>

---

# Riverpod generator

Welcome!

This project is a side package for Riverpod, meant to offer a different syntax for defining "providers" by relying on code generation.

Without any delay, here is how you

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

part 'my_file.g.dart';

// Using riverpod_generator, we define Providers by annotating functions with @riverpod.
// In this example, riverpod_generator will use this function and generate a matching "fetchProductProvider".
// The following example would be the equivalent of a "FutureProvider.autoDispose.family"
@riverpod
Future<List<Product>> fetchProducts(Ref ref, {required int page, int limit = 50}) async {
  final dio = Dio();
  final response = await dio.get('https://my-api/products?page=$page&limit=$limit');
  final json = response.data! as List;
  return json.map((item) => Product.fromJson(item)).toList();
}


// Now that we defined a provider, we can then listen to it inside widgets as usual.
Consumer(
  builder: (context, ref, child) {
    AsyncValue<List<Product>> products = ref.watch(fetchProductProvider(page: 1));

    // Since our provider is async, we need to handle loading/error states
    return products.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('error: $err'),
      data: (products) {
        return ListView(
          children: [
            for (final product in products)
              Text(product.name),
          ],
        );
      },
    );
  },
);
```

This new syntax has all the power of Riverpod, but also:

- solves the problem of knowing "What provider should I use?".  
  With this new syntax, there is no such thing as `Provider` vs `FutureProvider` vs ...
- enables stateful hot-reload for providers.  
  When modifying the source code of a provider, on hot-reload Riverpod will re-execute
  that provider _and only that provider_.
- fixes various flaws in the existing syntax.  
  For example, when passing parameters to providers by using [family], we are limited
  to a single positional parameter. But with this project, we can pass multiple parameters,
  and use all the features of function parameters. Including named parameters, optional
  parameters, default values, ...

This project is entirely optional. But if you don't mind code generation, definitely consider using it
over the default Riverpod syntax.

- [Riverpod generator](#riverpod-generator)
- [Getting started](#getting-started)
  - [Installing riverpod_generator](#installing-riverpod_generator)
  - [Starting the code generator](#starting-the-code-generator)
  - [Defining our first "provider"](#defining-our-first-provider)

# Getting started

## Installing riverpod_generator

To install riverpod_generator, edit your `pubspec.yaml` and add the following:

```yaml
dependencies:
  # or flutter_riverpod/hooks_riverpod as per https://riverpod.dev/docs/getting_started
  riverpod:
  # the annotation package containing @riverpod
  riverpod_annotation:

dev_dependencies:
  # a tool for running code generators
  build_runner:
  # the code generator
  riverpod_generator:
```

Don't forget to run `flutter pub get` / `dart pub get`.

## Starting the code generator

To start the code generator, run the following command:

```sh
dart run build_runner watch
```

## Defining our first "provider"

Now that we have installed riverpod_generator and started the code generator,
we can start defining providers.

Let's make a hello world using riverpod_generator:

```dart
// main.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

part 'main.g.dart';

// Providers are defined by annotating a function with @riverpod
@riverpod
String label(Ref ref) => 'Hello world';

void main() {
  runApp(ProviderScope(child: Home()));
}

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        // We can then listen to the generated provider in our widgets.
        body: Text(ref.watch(labelProvider)),
      ),
    );
  }
}
```

## Global configuration

You can change provider name suffix in the build.yaml file:

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          # Could be changed to "my", such that riverpod_generator
          # would generate "myCountProvider" instead of "countProvider"
          provider_name_prefix: "" # (default)
          # Similar to provider_name_prefix, this is an option for renaming
          # providers with parameters ("families").
          # This takes precedence over provider_name_prefix.
          provider_family_name_prefix: "" # (default)
          # Could be changed to "Pod", such that riverpod_generator
          # would generate "countPod" instead of "countProvider"
          provider_name_suffix: "Provider" # (default)
          # Similar to provider_name_suffix, this is an option for renaming
          # providers with parameters ("families").
          # This takes precedence over provider_name_suffix.
          provider_family_name_suffix: "Provider" # (default)
```

[family]: https://riverpod.dev/docs/concepts/modifiers/family
[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/riverpod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
