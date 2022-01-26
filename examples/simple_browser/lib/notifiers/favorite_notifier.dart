import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]);

  void add(String webPage) {
    List<String> favorites = List.from(state)..add(webPage);
    state = favorites;
  }

  void remove(String webPage) {
    List<String> favorites = List.from(state)..remove(webPage);
    state = favorites;
  }

}