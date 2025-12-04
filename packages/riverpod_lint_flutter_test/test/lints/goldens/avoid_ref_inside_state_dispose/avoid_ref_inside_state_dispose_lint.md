code: avoid_ref_inside_state_dispose
severity: Severity.warning
message: Avoid using 'Ref' inside State.dispose.
test/lints/avoid_ref_inside_state_dispose.dart:17:5

```dart
  void dispose() {
    // ignore: riverpod_lint/avoid_ref_inside_state_dispose
    >>>ref.read(provider)<<<;
    // ignore: riverpod_lint/avoid_ref_inside_state_dispose
    ref.watch(provider);
```

=======

code: avoid_ref_inside_state_dispose
severity: Severity.warning
message: Avoid using 'Ref' inside State.dispose.
test/lints/avoid_ref_inside_state_dispose.dart:19:5

```dart
    ref.read(provider);
    // ignore: riverpod_lint/avoid_ref_inside_state_dispose
    >>>ref.watch(provider)<<<;

    super.dispose();
```
