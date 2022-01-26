import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/favorite_notifier.dart';
import '../notifiers/show_favorite_notifier.dart';
import '../notifiers/web_page_notifier.dart';
import '../notifiers/web_view_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

final webViewProvider =
    StateNotifierProvider<WebViewNotifier, WebViewController?>(
        (ref) => WebViewNotifier());

final textEditingControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());

final webPageProvider = StateNotifierProvider<WebPageNotifier, String>(
        (ref) => WebPageNotifier());

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<String>>(
        (ref) => FavoriteNotifier());

final showHideFavoriteProvider =
    StateNotifierProvider<ShowFavoriteNotifier, bool>(
         (ref) => ShowFavoriteNotifier());

final showedFavoriteProvider = Provider<bool>(
        (ref) => ref.watch(showHideFavoriteProvider));

final addedWebPageToFavorite = Provider<bool>((ref)  {
   final String currentWebPage = ref.watch(webPageProvider);
   final List<String> favorites = ref.watch(favoriteProvider);

   return favorites.contains(currentWebPage);
});

