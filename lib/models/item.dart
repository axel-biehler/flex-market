/// Represents an item with name, category, imagesUrl, createdAt,
/// specs, stock, price, description and gender
class Item {
  /// Creates an [Item] with the given [id], [name], [category], [imagesUrl],
  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.imagesUrl,
    required this.createdAt,
    required this.specs,
    required this.stock,
    required this.price,
    required this.description,
    required this.gender,
  });

  /// Returns a [Item] from the given [json] map.
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imagesUrl: List<String>.from(json['imagesUrl']),
      createdAt: DateTime.parse(json['createdAt']),
      specs: json['specs'],
      stock: Map<String, int>.from(json['stock']),
      price: json['price'],
      description: json['description'],
      gender: json['gender'],
    );
  }

  /// id of the item.
  final String id;

  /// name of the item.
  final String name;

  /// category of the item.
  final String category;

  /// imagesUrl of the item.
  final List<String> imagesUrl;

  /// createdAt of the item.
  final DateTime createdAt;

  /// specs of the item.
  final Map<String, dynamic> specs;

  /// stock of the item.
  final Map<String, int> stock;

  /// price of the item.
  final double price;

  /// description of the item.
  final String description;

  /// gender of the item.
  final String gender;
}
