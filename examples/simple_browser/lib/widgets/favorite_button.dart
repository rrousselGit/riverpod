import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../resources/values_manager.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAddedWebPageToFavorite = ref.watch(addedWebPageToFavorite);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: IconButton(
        icon: Icon(isAddedWebPageToFavorite ?
          Icons.favorite :
          Icons.favorite_border,
          color: Colors.red,),
        onPressed: () {
          final webPage = ref.read(webPageProvider);

          isAddedWebPageToFavorite ?
              ref
                  .read(favoriteProvider.notifier)
                  .remove(webPage)
          :   ref
                  .read(favoriteProvider.notifier)
                  .add(webPage);
        },
      ),
    );
  }

}