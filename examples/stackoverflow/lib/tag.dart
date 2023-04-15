import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common.dart';

part 'tag.freezed.dart';

@freezed
class TagTheme with _$TagTheme {
  const factory TagTheme({
    required TextStyle style,
    required EdgeInsets padding,
    required Color backgroundColor,
    required BorderRadius borderRadius,
  }) = _TagTheme;
}

final tagThemeProvider = Provider<TagTheme>(
  (ref) {
    final theme = ref.watch(themeProvider);

    return TagTheme(
      padding: EdgeInsets.symmetric(
        horizontal: theme.textTheme.bodyLarge!.fontSize! * 0.5,
        vertical: theme.textTheme.bodyLarge!.fontSize! * 0.4,
      ),
      style: theme.textTheme.bodyMedium!.copyWith(
        color: const Color(0xff9cc3db),
      ),
      borderRadius: BorderRadius.circular(3),
      backgroundColor: const Color(0xFF3e4a52),
    );
  },
  dependencies: [themeProvider],
);

class Tag extends HookConsumerWidget {
  const Tag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagTheme = ref.watch(tagThemeProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: tagTheme.borderRadius,
        color: tagTheme.backgroundColor,
      ),
      padding: tagTheme.padding,
      child: Text(tag, style: tagTheme.style),
    );
  }
}
