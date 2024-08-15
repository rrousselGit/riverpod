<p>
  <a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
    <img src="https://raw.githubusercontent.com/rrousselGit/riverpod/master/resources/flutter_favorite.png" width="100" align="left" />
  </a>
  <a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
  <a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
  <a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
  <a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>

  <p>
    <a href="https://www.netlify.com">
      <img src="https://www.netlify.com/img/global/badges/netlify-color-accent.svg" alt="Deploys by Netlify" />
    </a>
  </p>

</p>

<p align="center">
  <img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

---

A reactive caching and data-binding framework. https://riverpod.dev
Riverpod makes working with asynchronous code a breeze by:

- handling errors/loading states by default. No need to manually catch errors
- natively supporting advanced scenarios, such as pull-to-refresh
- separating the logic from your UI
- ensuring your code is testable, scalable and reusable

| riverpod         | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=riverpod&color=blue)](https://pub.dartlang.org/packages/riverpod)                 |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flutter_riverpod | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=flutter_riverpod&color=blue)](https://pub.dartlang.org/packages/flutter_riverpod) |
| hooks_riverpod   | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=hooks_riverpod&color=blue)](https://pub.dartlang.org/packages/hooks_riverpod)     |

Welcome to [Riverpod] (anagram of [Provider])!

For learning how to use [Riverpod], see its documentation:
\>\>\> https://riverpod.dev <<<

Long story short:

- Define network requests by writing a function annotated with `@riverpod`:

  ```dart
  @riverpod
  Future<String> boredSuggestion(BoredSuggestionRef ref) async {
    final response = await http.get(
      Uri.https('boredapi.com', '/api/activity'),
    );
    final json = jsonDecode(response.body);
    return json['activity']! as String;
  }
  ```

- Listen to the network request in your UI and gracefully handle loading/error states.

  ```dart
  class Home extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final boredSuggestion = ref.watch(boredSuggestionProvider);
      // Perform a switch-case on the result to handle loading/error states
      return switch (boredSuggestion) {
        AsyncData(:final value) => Text('data: $value'),
        AsyncError(:final error) => Text('error: $error'),
        _ => const Text('loading'),
      };
    }
  }
  ```

## Contributing

Contributions are welcome!

Here is a curated list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Fix typos/grammar mistakes
- Update the documentation or add examples
- Implement new features by making a pull-request

## Sponsors

<p align="center">
  <a href="https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg">
    <img src='https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg'/>
  </a>
</p>

[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/riverpod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
