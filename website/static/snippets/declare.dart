// A shared state that can be accessed by multiple
// objects at the same time
final countProvider = StateProvider((ref) => 0);

// Comsumes the shared state and rebuild when it changes
class Title extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider).state;
    return Text('$count');
  }
}
