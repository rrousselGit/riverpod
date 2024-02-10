// ignore_for_file: avoid_unused_constructor_parameters

class Product {
  Product();
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product();
  }
}

class Configuration {
  Configuration({
    this.host = '',
  });

  final String host;
}
