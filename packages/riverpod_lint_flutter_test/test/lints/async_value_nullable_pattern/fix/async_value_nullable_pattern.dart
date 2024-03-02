import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // T is nullable, therefore we should check hasData
    case AsyncValue<int?>(
        // expect_lint: async_value_nullable_pattern
        :final value?
      ):
      print(value);
  }
}
