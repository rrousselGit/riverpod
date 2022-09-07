import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/home.dart';

class _SearchTheme {
  const _SearchTheme({
    required this.width,
    // ignore: unused_element, blocked by https://github.com/dart-lang/linter/issues/3232
    this.height = 300,
    required this.searchDecoration,
    required this.iconPadding,
    required this.searchMargin,
  });

  final double width;
  final double height;
  final BoxDecoration searchDecoration;
  final EdgeInsets iconPadding;
  final EdgeInsets searchMargin;
}

const _kFocusedTheme = _SearchTheme(
  width: 210,
  searchDecoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  iconPadding: EdgeInsets.only(right: 8),
  searchMargin: EdgeInsets.only(right: 10),
);

const _kUnfocusedTheme = _SearchTheme(
  width: 40,
  searchDecoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  iconPadding: EdgeInsets.zero,
  searchMargin: EdgeInsets.only(right: 10),
);

class SearchBar extends HookConsumerWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Whether the widget is focused or not determines if the widget
    /// is currently "searching" or in idle state.
    final searchFocusNode = useFocusNode();
    useListenable(searchFocusNode);
    final theme = searchFocusNode.hasFocus ? _kFocusedTheme : _kUnfocusedTheme;

    final textFocusNode = useFocusNode();
    final textEditingController = useTextEditingController();

    final hints = TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(
        begin: 0,
        end: searchFocusNode.hasFocus ? 1 : 0,
      ),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: _SearchHintContainer(
        theme: theme,
        child: _SearchHints(textEditingController: textEditingController),
      ),
    );

    final searchField = _SearchbarView(
      theme: theme,
      isFocused: searchFocusNode.hasFocus,
      textEditingController: textEditingController,
      textFocusNode: textFocusNode,
    );

    return Focus(
      focusNode: searchFocusNode,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 150),
        tween: Tween(end: theme.width),
        builder: (context, width, _) {
          return Center(
            child: SizedBox(
              width: width,
              child: PortalEntry(
                visible: width > 40 || searchFocusNode.hasFocus,
                childAnchor: Alignment.bottomCenter,
                portalAnchor: Alignment.topCenter,
                portal: SizedBox(width: width, child: hints),
                child: searchField,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchHints extends HookConsumerWidget {
  const _SearchHints({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useValueListenable(textEditingController).text;

    return ref.watch(charactersCount(search)).when(
          loading: () => const Center(
            heightFactor: 1,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => const Center(
            heightFactor: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Error'),
            ),
          ),
          data: (count) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: count,
              separatorBuilder: (context, _) => const Divider(height: 0),
              itemBuilder: (context, index) {
                return HookConsumer(
                  builder: (context, ref, child) {
                    final character = ref.watch(characterAtIndex(
                      CharacterOffset(offset: index, name: search),
                    ));

                    return character.when(
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                      error: (err, stack) => const Center(child: Text('Error')),
                      data: (character) {
                        return ListTile(
                          visualDensity: VisualDensity.compact,
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/characters/${character.id}');
                          },
                          title: Text(
                            character.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
  }
}

class _SearchHintContainer extends StatelessWidget {
  const _SearchHintContainer({
    Key? key,
    required this.theme,
    required this.child,
  }) : super(key: key);

  final _SearchTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: theme.height,
      ),
      margin: theme.searchMargin,
      child: Material(
        elevation: 16,
        borderRadius: theme.searchDecoration.borderRadius,
        clipBehavior: Clip.hardEdge,
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxHeight: theme.height,
          maxWidth: 300,
          child: child,
        ),
      ),
    );
  }
}

class _SearchbarView extends StatelessWidget {
  const _SearchbarView({
    Key? key,
    required this.theme,
    required this.isFocused,
    required this.textEditingController,
    required this.textFocusNode,
  }) : super(key: key);

  final _SearchTheme theme;
  final bool isFocused;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          // Don't unfocus when tapping the searchbar
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: theme.width,
            height: 35,
            margin: theme.searchMargin,
            decoration: theme.searchDecoration,
          ),
        ),
        Positioned.fill(
          left: 12,
          right: 50,
          child: ExcludeSemantics(
            excluding: !isFocused,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: textEditingController,
                focusNode: textFocusNode,
                scrollController: ScrollController(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Iron man',
                ),
              ),
            ),
          ),
        ),
        AnimatedTheme(
          data: isFocused //
              ? ThemeData.light()
              : ThemeData.dark(),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            padding: theme.iconPadding,
            child: IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search by name',
              onPressed: textFocusNode.requestFocus,
            ),
          ),
        ),
      ],
    );
  }
}
