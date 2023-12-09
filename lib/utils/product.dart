/// Represents a product with a title, image, and price.
///
/// This class is used to model the data structure for a product
/// in the application, encapsulating the essential fields that
/// define what a product is.
class Product {
  /// Creates a [Product] with the given [title], [imageUrl], and [price].
  Product({required this.title, required this.imageUrl, required this.price});

  /// The title of the product.
  final String title;

  /// The URL or path to the product's image.
  final String imageUrl;

  /// The price of the product.
  final double price;
}
