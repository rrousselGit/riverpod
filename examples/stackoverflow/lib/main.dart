import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common.dart';
import 'home.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final theme = Theme.of(context);

        return ProviderScope(
          overrides: [
            tagThemeProvider.overrideWithValue(
              TagTheme(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.textTheme.bodyText1!.fontSize! * 0.5,
                  vertical: theme.textTheme.bodyText1!.fontSize! * 0.4,
                ),
                style: theme.textTheme.bodyText2!.copyWith(
                  color: const Color(0xff9cc3db),
                ),
                borderRadius: BorderRadius.circular(3),
                backgroundColor: const Color(0xFF3e4a52),
              ),
            ),
            questionThemeProvider.overrideWithValue(
              const QuestionTheme(
                titleStyle: TextStyle(
                  color: Color(0xFF3ca4ff),
                  fontSize: 16,
                ),
                descriptionStyle: TextStyle(
                  color: Color(0xFFe7e8eb),
                  fontSize: 13,
                ),
              ),
            ),
          ],
          child: ListTileTheme(
            textColor: const Color(0xFFe7e8eb),
            child: child!,
          ),
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2d2d2d),
      ),
      home: const MyHomePage(),
    );
  }
}
