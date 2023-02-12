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

Riverpod_lint is a developper tool for users of Riverpod, designed to help stop common
issue and simplify repetetive tasks.

Riverpod_lint adds various warnings with quick fixes and refactoring options, such as:

- Warn if `runApp` does not include a `ProviderScope` at its root
- Warn if provider parameters do not respect [the rules of `family`](https://riverpod.dev/docs/concepts/modifiers/family#passing-multiple-parameters-to-a-family)
- Refactor a widget to a ConsumerWidget/ConsumerStatfulWidget
- ...

## Table of content

- [Table of content](#table-of-content)
- [Installing riverpod\_lint](#installing-riverpod_lint)
- [Enabling/disabling lints.](#enablingdisabling-lints)
  - [Disable one specific rule](#disable-one-specific-rule)
  - [Disable all lints by default](#disable-all-lints-by-default)
- [Running riverpod\_lint in the terminal/CI](#running-riverpod_lint-in-the-terminalci)
- [All the lints](#all-the-lints)
  - [missing\_provider\_scope](#missing_provider_scope)
    - [Good:](#good)
    - [Bad:](#bad)
  - [provider\_parameters](#provider_parameters)
    - [Good:](#good-1)
    - [Bad:](#bad-1)
  - [stateless\_ref](#stateless_ref)
    - [Good:](#good-2)
    - [Bad:](#bad-2)
  - [generator\_class\_extends](#generator_class_extends)
    - [Good:](#good-3)
    - [Bad:](#bad-3)
- [All assists](#all-assists)
  - [Wrap widget with a `Consumer`](#wrap-widget-with-a-consumer)
  - [Wrap widget with a `ProviderScope`](#wrap-widget-with-a-providerscope)
  - [Convert widget to `ConsumerWidget`](#convert-widget-to-consumerwidget)
  - [Convert widget to `ConsumerStatefulWidget`](#convert-widget-to-consumerstatefulwidget)
  - [Convert functional `@riverpod` to class variant](#convert-functional-riverpod-to-class-variant)
  - [Convert class `@riverpod` to functional variant](#convert-class-riverpod-to-functional-variant)
- [Upcoming content:](#upcoming-content)

## Installing riverpod_lint

Riverpod_lint is implemented using [custom_lint]. As such, it uses custom_lint's installation logic.  
Long story short:

- Add both riverpod_lint and custom_lint to your `pubspec.yaml`:
  ```yaml
  dev_dependencies:
    custom_lint:
    riverpod_lint:
  ```
- Enable `custom_lint`'s plugin in your `analysis_options.yaml`:

  ```yaml
  analyzer:
    plugins:
      - custom_lint
  ```

## Enabling/disabling lints.

By default when installing riverpod_lint, most of the lints will be enabled.
To change this, you have a few options.

### Disable one specific rule

You may dislike one of the various lint rules offered by riverpod_lint.
In that event, you can explicitly disable this lint rule for your project
by modifying the `analysis_options.yaml`

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Explicitly disable one lint rule
    - missing_provider_scope: false
```

Note that you can both enable and disable lint rules at once.
This can be useful if your `analysis_options.yaml` includes another one:

```yaml
include: path/to/another/analys_options.yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Enable one rule
    - provider_parameters
    # Disable another
    - missing_provider_scope: false
```

### Disable all lints by default

Instead of having all lints on by default and manually disabling lints of your choice,
you can switch to the opposite logic:  
Have lints off by default, and manually enable lints.

This can be done in your `analysis_options.yaml` with the following:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  # Forcibly disable lint rules by default
  enable_all_lint_rules: false
  rules:
    # You can now enable one specific rule in the "rules" list
    - missing_provider_scope
```

## Running riverpod_lint in the terminal/CI

Custom lint rules created by riverpod_lint may not show-up in `dart analyze`.
To fix this, you can run a custom command line: `custom_lint`.

Since your project should already have custom_lint installed
(cf [installing riverpod_lint](#installing-riverpod_lint)), then you should be
able to run:

```sh
dart pub custom_lint
```

Alternatively, you can globally install `custom_lint`:

```sh
# Install custom_lint for all projects
dart pub global activate custom_lint
# run custom_lint's command line in a project
custom_lint
```

## All the lints

### missing_provider_scope

Flutter applications using Riverpod should have a ProviderScope widget at the top
of the widget tree.

#### Good:

```dart
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

#### Bad:

```dart
void main() {
  runApp(MyApp());
}
```

### provider_parameters

Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==.

#### Good:

```dart
// Parameters may override ==
ref.watch(myProvider(ClassThatOverridesEqual()));

// Constant objects are canonalized and therefore have a consistent ==
ref.watch(myProvider(const Object()));
ref.watch(myProvider(const [42]));

// Passing a variable disable the lint, as the variable may be cached.
ref.watch(myProvider(variable));
```

#### Bad:

```dart
// New instances passed as provider parameter must override ==
ref.watch(myProvider(ClassWithNoCustomEqual()));
// List/map/set litterals do not have a custom ==
ref.watch(myProvider([42]));
```

### stateless_ref

Stateless providers must receive a ref matching the provider name as their first positional parameter.

#### Good:

```dart
@riverpod
int myProvider(MyProviderRef ref) => 0;
```

#### Bad:

```dart
// No "ref" parameter found
@riverpod
int myProvider() => 0;

// The ref parameter is not correctly typed (int -> MyProviderRef)
@riverpod
int myProvider(int ref) => 0;
```

### generator_class_extends

Classes annotated by `@riverpod` must extend \_$ClassName

#### Good:

```dart
@riverpod
class Example extends _$Example {
  int build() => 0;
}
```

#### Bad:

```dart
// No "extends" found
@riverpod
class Example {
  int build() => 0;
}

// An "extends" is present, but is not matching the class name
@riverpod
class Example extends Anything {
  int build() => 0;
}
```

## All assists

### Wrap widget with a `Consumer`

### Wrap widget with a `ProviderScope`

### Convert widget to `ConsumerWidget`

### Convert widget to `ConsumerStatefulWidget`

### Convert functional `@riverpod` to class variant

### Convert class `@riverpod` to functional variant

## Upcoming content:

- Warn if a provider's `dependencies` parameter doesn't match the `ref.watch/read/listen` usages.
- Refactoring to convert AsyncNotifier<>Notifier + autoDispose/family variants
- Warn if an `AsyncNotifierProvider.autoDispose` doesn't use an `AutoDisposeAsyncNotifier`

and much more

[custom_lint]: https://pub.dev/packages/custom_lint
