// IMPORTANT: Any change to this file must also be applied to:
// - The DartPad embed gist
//   https://gist.github.com/rrousselGit/6bf918e3fc97a40b53d1ea80fd937146
// - The website tutorial
//   https://riverpod.dev/docs/tutorials/first_app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'joke.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Joke Generator')),
      body: SizedBox.expand(
        child: Consumer(
          builder: (context, ref, _) {
            final randomJoke = ref.watch(randomJokeProvider);

            return Stack(
              alignment: Alignment.center,
              children: [
                if (randomJoke.isRefreshing)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),

                switch (randomJoke) {
                  AsyncValue(:final value?) => SelectableText(
                    '${value.setup}\n\n${value.punchline}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                  AsyncValue(error: != null) => const Text(
                    'Error fetching joke',
                  ),
                  AsyncValue() => const CircularProgressIndicator(),
                },

                Positioned(
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () => ref.invalidate(randomJokeProvider),
                    child: const Text('Get another joke'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
