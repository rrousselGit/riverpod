Here, you will find the list of all providers (excluding the "legacy" ones)  
You can safely pick a provider from this list and be sure that its usage is recommended.

## What is a provider

Providers are the most important components of `Riverpod`. In short, you can think
of providers as an access point to a **shared state**.

Providers solve the following problems:

- Providers have the flexibility of global variables, without their downsides.\
  Providers can be accessed from anywhere, while ensuring testability and scalability.

- Providers are safe to use.\
  As opposed to most service-locator solutions, using a provider, it is not
  possible to read a value in an uninitialized state.\
  If we can write the code to read a state, the code will execute properly.
  Even if the state is loaded asynchronously.

- Providers allow easily and efficiently listening to a piece of state.\
  They can be accessed in a single line of code, and offer many ways to optimize
  your application.

## Creating a provider

Providers come in many variants, but they all work the same way.

The most common usage is to declare them as global variables like so:

```dart
final myProvider = Provider((ref) {
  return MyValue();
});
```

**NOTE**
Do not feel threatened by the fact that a provider is declared as a global.
While providers are globals, the variable is fully immutable.
This makes creating a provider no different from declaring a function or a class.

This snippet consist of three components:

- `final myProvider`, the declaration of a variable.\
  This variable is what we will use in the future to read the state of our provider.
  It should always be immutable.

- `Provider`, the provider that we decided to use.\
  [Provider] is the most basic of all providers. It exposes an object that never
  changes.\
  We could replace [Provider] with other providers like [StreamProvider] or
  [StateNotifierProvider], to change how the value is interacted with.

- A function that creates the shared state.\
  That function will always receive an object called `ref` as a parameter. This object
  allows us to read other providers or to perform some operations when the state
  of our provider will be destroyed.

The type of the object created by the function passed to a provider depends on
the provider used.\
 For example, the function of a [Provider] can create any object.
On the other hand, [StreamProvider]'s callback will be expected to return a [Stream].

**NOTE**:
You can declare as many providers as you want, without limitations.\
 As opposed to when using `package:provider`, in `Riverpod` we can have two
providers expose a state of the same "type":

```dart
final cityProvider = Provider((ref) => 'London');
final countryProvider = Provider((ref) => 'England');
```

The fact that both providers create a `String` does not cause conflicts.
We will be able to read both values independently from each other without issue.

**WARNING**
For providers to work, you need to add `ProviderScope` at the root of your
Flutter applications:

```dart
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

## Combining providers

We've previously seen how to create a simple provider. But the reality is,
in many situations a provider will want to read the state of another provider.

To do that, we can use the `ref` object passed to the callback of our provider,
and use its `watch` method.

As an example, consider the following provider:

```dart
final cityProvider = Provider((ref) => 'London');
```

We can now create another provider that will consume our `cityProvider`:

```dart
final weatherProvider = FutureProvider((ref) async {
  // We use `ref.watch` to watch another provider, and we pass it the provider
  // that we want to consume. Here: cityProvider
  final city = ref.watch(cityProvider);

  // We can then use the result to do something based on the value of `cityProvider`.
  return fetchWeather(city: city);
});
```

That's it. We've created a provider that depends on another provider.

One interesting aspect of this code is, if `city` ever changes,
this will automatically call `fetchWeather` again and update the UI accordingly.

### Creating an object that depends on a lot of providers.

Sometimes, we may want to create an object that depends on a lot of providers
like so:

```dart
final cityProvider = Provider((ref) => 'London');
final countryProvider = Provider((ref) => 'England');

final weatherProvider = Provider((ref) {
  final city = ref.watch(cityProvider);
  final country = ref.watch(countryProvider);

  return Location(city: city, country: country);
});

class Location {
  Location({required this.city, required this.country});

  final String city;
  final String country;

  String get label => '$city ($country)';
}
```

This can quickly become tedious.

In that situation, it may be reasonable to pass the `ref` variable to our
object directly:

```dart
final cityProvider = Provider((ref) => 'London');
final countryProvider = Provider((ref) => 'England');

final weatherProvider = Provider((ref) {
  // Pass the `ref` object to our `Location` class.
  // `Location` will then be able to call `ref.read` to read the providers.
  return Location(ref);
});

class Location {
  Location(this._ref);

  final Ref _ref;

  String get label {
    final city = _ref.read(cityProvider);
    final country = _ref.read(countryProvider);
    return '$city ($country)';
  }
}
```

This avoids having to implement a constructor, which makes changes on the object
easier.

This is fine as, as opposed to `BuildContext` from Flutter, that `ref` object
is completely independent from Flutter/the UI.\
 As such the object can still be shared and tested.

## Disposing the resources the state is destroyed

During the lifetime of an application, the state associated with a provider may
get destroyed.\
 In this situation, we may want to perform a clean-up before the state destruction.

This is done by using the `ref` object that is passed to the callback of all providers.

That `ref` object exposes an `onDispose` method, which can be used to listen to
the state destruction even to perform some task.

The following example uses `ref.onDispose` to close a `StreamController`:

```dart
final example = StreamProvider.autoDispose((ref) {
  final streamController = StreamController<int>();

  ref.onDispose(() {
    // Closes the StreamController when the state of this provider is destroyed.
    streamController.close();
  });

  return streamController.stream;
});
```

See also:

- [Provider.autoDispose], to automatically destroy the state of a provider
  when that provider is no longer listened to.
- [Provider.family], to allow providers to create a value from external parameters.
