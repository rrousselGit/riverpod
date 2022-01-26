import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowFavoriteNotifier extends StateNotifier<bool> {
  ShowFavoriteNotifier() : super(false);

  void showFavorite(bool favorite) {
    state = favorite;
  }

}