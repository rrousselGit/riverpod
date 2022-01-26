import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextField(
        style: const TextStyle(color: Colors.black,),
        controller: ref.read(textEditingControllerProvider),
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.red,),
          hintText: AppStrings.search,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.s15),
            borderSide: BorderSide.none
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        onSubmitted: (_) {
          final textEditingController =
                 ref.read(textEditingControllerProvider);

          FocusScope.of(context).unfocus();

          ref
              .read(webViewProvider.notifier)
              .openWebPage(url: textEditingController.text);

          textEditingController.clear();
        },
      ),
    );
  }
}
