extension StringX on String {
  String indentWith(String indent) {
    final split = this.split('\n');

    return split.indexed
        .map((e) {
          if (e.$1 == split.length - 1 && e.$2.isEmpty) return '';

          return '$indent${e.$2}';
        })
        .join('\n');
  }
}
