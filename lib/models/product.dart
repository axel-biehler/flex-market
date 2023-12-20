import 'package:flex_market/utils/enums.dart';

/// Represents a product with a title, image, price and size.
///
/// This class is used to model the data structure for a product
/// in the application, encapsulating the essential fields that
/// define what a product is.
class Product {
  /// Creates a [Product] with the given [title], [imageUrl], [price] and [size].
  Product({required this.title, required this.imageUrl, required this.price, required this.size});

  /// The title of the product.
  final String title;

  /// The URL or path to the product's image.
  final String imageUrl;

  /// The price of the product.
  final double price;

  /// The size of the product.
  final ItemSize size;
}
