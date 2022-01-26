import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../resources/values_manager.dart';

class UpDownButton extends ConsumerWidget {
  const UpDownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowedFavoriteProvider = ref.watch(showedFavoriteProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: IconButton(
        icon: Icon(isShowedFavoriteProvider ?
          Icons.arrow_downward :
          Icons.arrow_upward,
          color: Colors.red,),
        onPressed: () => ref
            .read(showHideFavoriteProvider.notifier)
            .showFavorite(!isShowedFavoriteProvider)
      ),
    );
  }

}