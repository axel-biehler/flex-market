import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Manages the application state including user authentication,
/// product data, and shopping cart functionality.
///
/// This class acts as a central hub for the state management within
/// the application, leveraging Flutter's Provider package for state
/// notification and updates.
class DataProvider extends ChangeNotifier {
  /// The shopping cart containing a list of products.
  final List<Product> _cart = <Product>[];

  /// Getter for the user's cart.
  List<Product> get cart => _cart;

  /// A list of mock products used for displaying in the UI.
  List<Product> mockProducts = <Product>[
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.l,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.m,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.xl,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.s,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.xl,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.xxl,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.l,
    ),
    Product(
      title: 'Air force one',
      imageUrl: 'assets/shoes.png',
      price: 189.90,
      size: ItemSize.m,
    ),
  ];

  /// Adds a product to the shopping cart and notifies listeners.
  void addToCart(Product product) {
    if (kDebugMode) {
      print('add to card $product');
    }
    _cart.add(product);
    if (kDebugMode) {
      print('cart $_cart');
    }
    notifyListeners();
  }

  /// Fetches data from a specified API endpoint and handles the response.
  Future<void> fetchData(Credentials credentials) async {
    final Uri url = Uri.parse(
      'https://x2rkz2iy7h.execute-api.eu-west-3.amazonaws.com/hello',
    );

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response data: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
