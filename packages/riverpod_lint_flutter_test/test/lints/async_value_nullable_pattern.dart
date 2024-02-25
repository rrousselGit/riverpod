import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  switch (Object()) {
    // T is nullable, therefore we should check hasData
    case AsyncValue<int?>(
        // expect_lint: async_value_nullable_pattern
        :final value?,
      ):
      print(value);
  }

  switch (Object()) {
    // Using hasValue on nullable generic, all is good
    case AsyncValue<int?>(
        :final value,
        hasValue: true,
      ):
      print(value);
  }

  switch (Object()) {
    // Pattern performed on AsyncData, so we don't care
    case AsyncData<int?>(:final value?):
      print(value);
  }

  switch (Object()) {
    // On AsyncError/AsyncLoading, we still need hasData
    case AsyncError<int?>(
        // expect_lint: async_value_nullable_pattern
        :final value?,
      ):
      print(value);
    case AsyncLoading<int?>(
        // expect_lint: async_value_nullable_pattern
        :final value?,
      ):
      print(value);
  }

  switch (Object()) {
    // Using hasValue on non-nullable generic.
    // We could use :final value?, but that's just a style.
    case AsyncValue<int>(
        :final value,
        hasValue: true,
      ):
      print(value);
  }

  switch (Object()) {
    // Non-nullable generic, :final value? is allowed
    case AsyncValue<int>(:final value?):
      print(value);
  }
}

void fn<T>(T obj) {
  switch (obj) {
    // expect_lint: async_value_nullable_pattern
    case AsyncValue<T>(:final value?):
      print(value);
  }
}

void fn2<T extends Object>(T obj) {
  switch (obj) {
    case AsyncValue<T>(:final value?):
      print(value);
  }
}

void fn3<T extends Object?>(T obj) {
  switch (obj) {
    // expect_lint: async_value_nullable_pattern
    case AsyncValue<T>(:final value?):
      print(value);
  }
}
