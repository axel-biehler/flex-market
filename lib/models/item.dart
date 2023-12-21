import 'dart:convert';

import 'package:flex_market/utils/enums.dart';

/// Represents an item with name, category, imagesUrl, createdAt,
/// specs, stock, price, description and gender
class Item {
  /// Creates an [Item] with the given [id], [name], [category], [imagesUrl],
  /// [specs], [createdAt], [stock], [price], [description] and [gender].
  Item({
    required this.name,
    required this.category,
    required this.imagesUrl,
    required this.specs,
    required this.stock,
    required this.price,
    required this.description,
    required this.gender,
    this.id,
    this.createdAt,
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
      price: json['price'].toDouble(),
      description: json['description'],
      gender: json['gender'],
    );
  }

  /// Returns a [Item] from the given form datas.
  factory Item.formForm(
    String name,
    Category category,
    String description,
    Map<String, int?> stocks,
    Map<String, dynamic> specs,
    double price,
    Gender gender,
    String? id,
  ) {
    return Item(
      name: name,
      category: category.name.toUpperCase(),
      description: description,
      stock: Map<String, int>.from(stocks),
      specs: specs,
      price: price,
      gender: gender.name.toUpperCase(),
      imagesUrl: <String>[],
      id: id,
    );
  }

  /// Returns a JSON String from the Item object
  String toJson() {
    return jsonEncode(<String, Object>{
      'name': name,
      'description': description,
      'price': price,
      'specs': specs,
      'stock': stock,
      'imagesUrl': imagesUrl,
      'gender': gender,
      'category': category,
    });
  }

  /// Method to calculate total stock
  int get totalStock {
    return stock.values.fold(0, (int sum, int quantity) => sum + quantity);
  }

  /// id of the item.
  final String? id;

  /// name of the item.
  final String name;

  /// category of the item.
  final String category;

  /// imagesUrl of the item.
  final List<String> imagesUrl;

  /// createdAt of the item.
  final DateTime? createdAt;

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
