class Public {
  const Public.inLibrary(this.library, {this.packageName});

  /// The name of the library which should show this public API.
  final String library;
  final String? packageName;
}
