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

Riverpod_lint is a developer tool for users of Riverpod, designed to help stop common
issues and simplify repetitive tasks.

Riverpod_lint adds various warnings with quick fixes and refactoring options, such as:

- Warn if `runApp` does not include a `ProviderScope` at its root
- Warn if provider parameters do not respect [the rules of `family`](https://riverpod.dev/docs/concepts/modifiers/family#passing-multiple-parameters-to-a-family)
- Refactor a widget to a ConsumerWidget/ConsumerStatefulWidget
- ...

![Convert to ConsumerStatefulWidget sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/convert_to_stateful_consumer.gif)

## Table of content

- [Table of content](#table-of-content)
- [Installing riverpod\_lint](#installing-riverpod_lint)
- [Enabling/disabling lints.](#enablingdisabling-lints)
  - [Disable one specific rule](#disable-one-specific-rule)
  - [Disable all lints by default](#disable-all-lints-by-default)
- [Running riverpod\_lint in the terminal/CI](#running-riverpod_lint-in-the-terminalci)
- [All the lints](#all-the-lints)
  - [missing\_provider\_scope](#missing_provider_scope)
  - [provider\_dependencies (riverpod\_generator only)](#provider_dependencies-riverpod_generator-only)
  - [scoped\_providers\_should\_specify\_dependencies (generator only)](#scoped_providers_should_specify_dependencies-generator-only)
  - [avoid\_manual\_providers\_as\_generated\_provider\_dependency](#avoid_manual_providers_as_generated_provider_dependency)
  - [avoid\_build\_context\_in\_providers (riverpod\_generator only)](#avoid_build_context_in_providers-riverpod_generator-only)
  - [provider\_parameters](#provider_parameters)
  - [avoid\_public\_notifier\_properties](#avoid_public_notifier_properties)
  - [unsupported\_provider\_value (riverpod\_generator only)](#unsupported_provider_value-riverpod_generator-only)
  - [functional\_ref (riverpod\_generator only)](#functional_ref-riverpod_generator-only)
  - [notifier\_extends (riverpod\_generator only)](#notifier_extends-riverpod_generator-only)
  - [avoid\_ref\_inside\_state\_dispose](#avoid_ref_inside_state_dispose)
  - [notifier\_build (riverpod\_generator only)](#notifier_build-riverpod_generator-only)
  - [async\_value\_nullable\_patttern](#async_value_nullable_patttern)
- [protected\_notifier\_properties](#protected_notifier_properties)
- [All assists](#all-assists)
  - [Wrap widgets with a `Consumer`](#wrap-widgets-with-a-consumer)
  - [Wrap widgets with a `ProviderScope`](#wrap-widgets-with-a-providerscope)
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
include: path/to/another/analysis_options.yaml
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
dart run custom_lint
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

**Good**:

```dart
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

**Bad**:

```dart
void main() {
  runApp(MyApp());
}
```

### provider_dependencies (riverpod_generator only)

If a provider depends on providers which specify `dependencies`, they should
specify `dependencies` and include all the scoped providers.

This lint only works for providers using the `@riverpod` annotation.

Consider the following providers:

```dart
// A non-scoped provider
@riverpod
int root(Ref ref) => 0;

// A possibly scoped provider
@Riverpod(dependencies: [])
int scoped(Ref ref) => 0;
```

**Good**:

```dart
// No dependencies used, no need to specify "dependencies"
@riverpod
int example(Ref ref) => 0;

// We can specify an empty "dependencies" list if we wish to.
// This marks the provider as "scoped".
@Riverpod(dependencies: [])
int example(Ref ref) => 0;

@riverpod
void example(Ref ref) {
  // rootProvider is not scoped, no need to specify it as "dependencies"
  ref.watch(rootProvider);
}

@Riverpod(dependencies: [scoped])
void example(Ref ref) {
  // scopedProvider is scoped and as such specifying "dependencies" is required.
  ref.watch(scopedProvider);
}
```

**Bad**:

```dart
// scopedProvider isn't used and should therefore not be listed
@Riverpod(dependencies: [scoped])
int example(Ref ref) => 0;

@Riverpod(dependencies: [])
void example(Ref ref) {
  // scopedProvider is used but not present in the list of dependencies
  ref.watch(scopedProvider);
}

@Riverpod(dependencies: [root])
void example(Ref ref) {
  // rootProvider is not a scoped provider. As such it shouldn't be listed in "dependencies"
  ref.watch(rootProvider);
}
```

### scoped_providers_should_specify_dependencies (generator only)

Providers that do not specify "dependencies" shouldn't be overridden in a
`ProviderScope`/`ProviderContainer` that is possibly not at the root of the tree.

Consider the following providers:

```dart
@Riverpod(dependencies: [])
int scoped(Ref ref) => 0;

@riverpod
int root(Ref ref) => 0;
```

(Providers defined without `riverpod_generator` are not supported)

**Good**

```dart
void main() {
  runApp(
    ProviderScope(
      // This is the main ProviderScope. All providers can be overridden there
      overrides: [
        rootProvider.overrideWith(...),
        scopedProvider.overrideWith(...),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // This ProviderScope is not the root one, so only providers with "dependencies"
      // can be specified.
      overrides: [
        scopedProvider.overrideWith(...),
      ],
      child: Container(),
    );
  }
}
```

**Bad**:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        // This ProviderScope is not the root one, so only providers with "dependencies"
      // can be specified.
      overrides: [
        // rootProvider does not specify "dependencies" and therefore should not
        // be overridden here.
        rootProvider.overrideWith(...),
      ],
      child: Container(),
    );
  }
}
```

### avoid_manual_providers_as_generated_provider_dependency

Providers using riverpod_generator should not depend on providers which do not use riverpod_generator.
Failing to do so would break the [provider_dependencies](#provider_dependencies-riverpod_generator-only) lint.

**Good**:

```dart
@riverpod
int dep(Ref ref) => 0;

@riverpod
void example(Ref ref) {
  /// Generated providers can depend on other generated providers
  ref.watch(depProvider);
}
```

**Bad**:

```dart
final depProvider = Provider((ref) => 0);

@riverpod
void example(Ref ref) {
  // Generated providers should not depend on non-generated providers
  ref.watch(depProvider);
}
```

### avoid_build_context_in_providers (riverpod_generator only)

Providers should not interact with `BuildContext`.

**Good**:

```dart
@riverpod
int fn(Ref ref) => 0;

@riverpod
class MyNotifier extends _$MyNotifier {
  int build() => 0;

  void event() {}
}
```

**Bad**:

```dart
// Providers should not receive a BuildContext as a parameter.
int fn(Ref ref, BuildContext context) => 0;

@riverpod
class MyNotifier extends _$MyNotifier {
  int build() => 0;

  // Notifiers should not have methods that receive a BuildContext as a parameter.
  void event(BuildContext context) {}
}
```

### provider_parameters

Providers' parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==.

**Good**:

```dart
// Parameters may override ==
ref.watch(myProvider(ClassThatOverridesEqual()));

// Constant objects are canonalized and therefore have a consistent ==
ref.watch(myProvider(const Object()));
ref.watch(myProvider(const [42]));

// Passing a variable disable the lint, as the variable may be cached.
ref.watch(myProvider(variable));
```

**Bad**:

```dart
// New instances passed as provider parameter must override ==
ref.watch(myProvider(ClassWithNoCustomEqual()));
// List/map/set litterals do not have a custom ==
ref.watch(myProvider([42]));
```

### avoid_public_notifier_properties

The `Notifier`/`AsyncNotifier` classes should not have a public state outside
of the `state` property.

The reasoning is that all "state" should be accessed through the `.state` property.
There should never be a case where you do `ref.watch(someProvider.notifier).someState`.
Instead, you should do `ref.watch(provider).someState`.

**Bad**:

```dart
@riverpod
class GeneratedNotifier extends _$GeneratedNotifier {
  // Notifiers should not have public properties/getters
  int b = 0;

  @override
  int build() => 0;
}
```

**Good**:

```dart
class Model {
  Model(this.a, this.b);
  final int a;
  final int b;
}

// Notifiers using the code-generator
@riverpod
class MyNotifier extends _$MyNotifier {
  // No public getters/fields, this is fine. Instead
  // Everything is available in the `state` object.
  @override
  Model build() => Model(0, 0);
}
```

```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  // Alternatively, notifiers are allowed to have properties/getters if they
  // are either private or annotated such that using inside widgets would
  // trigger a warning.
  int _internal = 0;
  @protected
  int publicButProtected = 0;
  @visibleForTesting
  int testOnly = 0;

  @override
  Something build() {...}
}
```

### unsupported_provider_value (riverpod_generator only)

The riverpod_generator package does not support `StateNotifier`/`ChangeNotifier` and
manually creating a `Notifier`/`AsyncNotifier`.

This lint warns against unsupported value types.

**Note**:

In some cases, you may voluntarily want to return a `ChangeNotifier` & co, even though
riverpod_generator will neither listen nor disposes of the value.  
In that scenario, you may explicitly wrap the value in `Raw`:

**Good**:

```dart
@riverpod
int integer(Ref ref) => 0;

@riverpod
class IntegerNotifier extends _$IntegerNotifier {
  @override
  int build() => 0;
}

// By using "Raw", we can explicitly return a ChangeNotifier in a provider
// without triggering `unsupported_provider_value`.
@riverpod
Raw<GoRouter> myRouter(Ref ref) {
  final router = GoRouter(...);
  // Riverpod won't dispose the ChangeNotifier for you in this case. Don't forget
  // to do it on your own!
  ref.onDispose(router.dispose);
  return router;
}
```

**Bad**:

```dart
// KO: riverpod_generator does not support creating StateNotifier/ChangeNotifiers/...
// Instead annotate a class with @riverpod.
@riverpod
MyStateNotifier stateNotifier(Ref ref) => MyStateNotifier();

class MyStateNotifier extends StateNotifier<int> {
  MyStateNotifier(): super(0);
}
```

### functional_ref (riverpod_generator only)

Functional providers must receive a ref matching the provider name as their first positional parameter.

**Good**:

```dart
@riverpod
int myProvider(Ref ref) => 0;
```

**Bad**:

```dart
// No "ref" parameter found
@riverpod
int myProvider() => 0;

// The ref parameter is not correctly typed (int -> Ref)
@riverpod
int myProvider(int ref) => 0;
```

### notifier_extends (riverpod_generator only)

Classes annotated by `@riverpod` must extend \_$ClassName

**Good**:

```dart
@riverpod
class Example extends _$Example {
  int build() => 0;
}
```

**Bad**:

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

### avoid_ref_inside_state_dispose

Avoid using `Ref` in the dispose method.

**Bad**:

```dart
class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  void dispose() {
    // Do not use 'ref' in the dispose method
    ref.read(provider).doSomething();
    super.dispose();
  }

  // ...
}
```

### notifier_build (riverpod_generator only)

Classes annotated by `@riverpod` must have the `build` method.

**Good**:

```dart
@riverpod
class Example extends _$Example {

  @override
  int build() => 0;
}
```

**Bad**:

```dart
// No "build" method found
@riverpod
class Example extends _$Example {}
```

### async_value_nullable_patttern

Warn if the pattern `AsyncValue(:final value?)` is used when the data
is possibly nullable.

**Bad**:

```dart
switch (...) {
  // int? is nullable, therefore ":final value?" should not be used
  case AsyncValue<int?>(:final value?):
     print('data $value');
}
```

**Good**:

```dart
switch (...) {
  // int is non-nullable, so using ":final value?" is fine.
  case AsyncValue<int>(:final value?):
     print('data $value');
}
```

```dart
switch (...) {
  // int? is nullable, therefore we use "hasValue: true"
  case AsyncValue<int?>(:final value, hasValue: true):
     print('data $value');
}
```

## protected_notifier_properties

Notifiers should not access the state of other notifiers.

This includes `.state`, `.future`, and `.ref`.

**Bad**:

```dart
@riverpod
class A extends _$A {
  @override
  int build() => 0;
}

@riverpod
class B extends _$B {
  @override
  int build() => 0;

  void doSomething() {
    // KO: Reading protected properties
    ref.read(aProvider.notifier).state++;
  }
}
```

**Good**:

```dart
@riverpod
class A extends _$A {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}

@riverpod
class B extends _$B {
  @override
  int build() => 0;

  void doSomething() {
    // Only access what notifiers explicitly enables us to.
    ref.read(aProvider.notifier).increment();
  }
}
```

## All assists

### Wrap widgets with a `Consumer`

![Wrap with Consumer sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/wrap_with_consumer.gif)

### Wrap widgets with a `ProviderScope`

![Wrap with ProviderScope sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/wrap_with_provider_scope.gif)

### Convert widget to `ConsumerWidget`

![Convert to ConsumerWidget sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/convert_to_consumer_widget.gif)

### Convert widget to `ConsumerStatefulWidget`

![Convert to ConsumerStatefulWidget sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/convert_to_stateful_consumer.gif)

### Convert functional `@riverpod` to class variant

![Convert provider to class variant sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/convert_to_class_provider.gif)

### Convert class `@riverpod` to functional variant

![Convert provider to functional variant sample](https://raw.githubusercontent.com/rrousselGit/riverpod/master/packages/riverpod_lint/resources/convert_to_functional_provider.gif)

## Upcoming content:

- Warn if a provider's `dependencies` parameter doesn't match the `ref.watch/read/listen` usages.
- Refactoring to convert AsyncNotifier<>Notifier + autoDispose/family variants
- Warn if an `AsyncNotifierProvider.autoDispose` doesn't use an `AutoDisposeAsyncNotifier`

and much more

[custom_lint]: https://pub.dev/packages/custom_lint
