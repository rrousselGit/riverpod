import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class FavoritePages extends ConsumerWidget {
  const FavoritePages({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);

    return Container(
      margin: const EdgeInsets.all(AppSize.s6),
      height: AppSize.s60,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: favorites.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (content, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: _buildChip(
                      favorites[index], ref,
                      Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  ),
                )
              ],
            );
          }
      ),
    );
  }
  
  Widget _buildChip(String label, WidgetRef ref, Color color){
    var avatarText = label
        .replaceAll(AppStrings.https, "")
        .replaceAll(AppStrings.http, "");

    return RawChip(
      labelPadding: const EdgeInsets.all(AppSize.s2),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(avatarText[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: AppSize.s6,
      shadowColor: Colors.grey,
      padding: const EdgeInsets.all(AppSize.s8),
      onDeleted: () => ref.read(favoriteProvider.notifier).remove(label),
      onPressed: () => ref.read(webViewProvider.notifier).openWebPage(url: label)
    );
  }
  
}