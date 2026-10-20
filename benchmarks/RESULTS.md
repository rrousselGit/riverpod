# Scope creation/disposal results

Creating a `ProviderScope` with any override used to copy the parent's whole
pointer table, so it cost O(providers mounted in the application) rather than
O(overrides). Disposal paid it too, since a full copy means the teardown walks
every provider in the application to find the few the scope owns.

Both tables are now forked lazily, and a scope materialises only what is read
through it.

## Method

```sh
dart compile exe benchmarks/lib/scope_bench.dart -o /tmp/scope_bench
/tmp/scope_bench
```

AOT, so `kReleaseMode` is on and the numbers are release-representative.
Median of 11 runs of 5000 iterations each, on an Apple-silicon macOS machine.
Only `ProviderContainer(parent:, overrides:)` and `dispose()` are timed; the
root is built outside the timed region.

Absolute values are machine-specific — the shape is the point: every row is now
flat with respect to how large the root is.

## Results

| Op      | Root shape                                 | Before   | After  | Change       |
|---------|--------------------------------------------|----------|--------|--------------|
| create  | empty root (floor)                         | 701 ns   | 100 ns | 7x faster    |
| create  | 100 orphan providers                       | 6.7 µs   | 166 ns | 40x faster   |
| create  | 1000 orphan providers                      | 43.0 µs  | 132 ns | 325x faster  |
| create  | 100 families x10, no `dependencies`        | 6.3 µs   | 145 ns | 44x faster   |
| create  | 500 families x10, no `dependencies`        | 24.8 µs  | 125 ns | 199x faster  |
| create  | 100 families x10, `dependencies: const []` | 60.1 µs  | 104 ns | 579x faster  |
| create  | 500 families x10, `dependencies: const []` | 332.7 µs | 124 ns | 2674x faster |
| create  | mixed app                                  | 107.3 µs | 108 ns | 989x faster  |
| dispose | empty root (floor)                         | 238 ns   | 247 ns | unchanged    |
| dispose | 100 orphan providers                       | 2.2 µs   | 241 ns | 9x faster    |
| dispose | 1000 orphan providers                      | 15.7 µs  | 390 ns | 40x faster   |
| dispose | 100 families x10, `dependencies: const []` | 18.9 µs  | 748 ns | 25x faster   |
| dispose | 500 families x10, `dependencies: const []` | 162.1 µs | 259 ns | 627x faster  |
| dispose | mixed app                                  | 84.5 µs  | 972 ns | 87x faster   |

The floor row is a scope over an empty root, where there was never anything to
copy. Its creation still improves because a container no longer generates a v4
UUID it only needs for the devtool; its disposal is unchanged, as expected.

`dependencies: const []` is called out separately because the old filter treated
it very differently from a family declaring nothing: a family with no
`dependencies` shared its directory with the parent and was already cheap, while
one declaring `dependencies: const []` had every instance copied into every
scope. That was the single most expensive case, and is the one codegen produces
for a provider annotated `@Riverpod(dependencies: [])`.
