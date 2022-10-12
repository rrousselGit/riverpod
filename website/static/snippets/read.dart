// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

/* SNIPPET START */

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boredSuggestion = ref.watch(boredSuggestionProvider);
    // Perform a switch-case on the result to handle loading/error states
    return boredSuggestion.when(
      loading: () => Text('loading'),
      error: (error, stackTrace) => Text('error: $error'),
      data: (data) => Text(data),
    );
  }
}