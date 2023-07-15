// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create.dart';

/* SNIPPET START */

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
