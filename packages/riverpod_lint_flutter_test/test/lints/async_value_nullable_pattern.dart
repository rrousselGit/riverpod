@TestFor.async_value_nullable_pattern
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../test_annotation.dart';

void main() {
  switch (Object()) {
    // T is nullable, therefore we should check hasData
    case AsyncValue<int?>(
      // ignore: riverpod_lint/async_value_nullable_pattern
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
      // ignore: riverpod_lint/async_value_nullable_pattern
      :final value?,
    ):
      print(value);
    case AsyncLoading<int?>(
      // ignore: riverpod_lint/async_value_nullable_pattern
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

void fn<TestT>(TestT obj) {
  switch (obj) {
    // ignore: riverpod_lint/async_value_nullable_pattern
    case AsyncValue<TestT>(:final value?):
      print(value);
  }
}

void fn2<TestT extends Object>(TestT obj) {
  switch (obj) {
    case AsyncValue<TestT>(:final value?):
      print(value);
  }
}

void fn3<TestT extends Object?>(TestT obj) {
  switch (obj) {
    // ignore: riverpod_lint/async_value_nullable_pattern
    case AsyncValue<TestT>(:final value?):
      print(value);
  }
}
