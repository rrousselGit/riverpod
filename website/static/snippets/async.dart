// Parse a file without having to deal with errors
final configurationsProvider = FutureProvider((ref) async {
  final json = await File.fromUri(Uri.parse('configs.json')).readAsString();
  return Configurations.fromJson(json);
});

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(configurationsProvider);

    // Use Riverpod's built-in support
    // for error/loading states using "when":
    return configs.when(
      loading: (_) => const CircularProgressIndicator(),
      error: (err, stack, _) => Text('Error $err'),
      data: (configs) => Text('data: ${configs.host}'),
    );
  }
}
