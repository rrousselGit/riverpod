// ignore_for_file: sort_constructors_first

class Product {
  const Product({this.title = ''});
  
  final String title;

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      title: map['title'] as String,
    );
  }
}

class Configuration {
  Configuration({
    this.host = '',
  });

  final String host;
}
