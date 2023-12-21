import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/models/cart_item.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/models/product.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Manages the application state including user authentication,
/// product data, and shopping cart functionality.
///
/// This class acts as a central hub for the state management within
/// the application, leveraging Flutter's Provider package for state
/// notification and updates.
class CartProvider extends ChangeNotifier {
  /// Constructor that receives the AuthProvider
  CartProvider(this.authProvider);

  /// Reference to the AuthProvider
  AuthProvider authProvider;

  /// The shopping cart containing a list of products.
  final List<CartItem> _cart = <CartItem>[];

  /// Getter for the user's cart.
  List<CartItem> get cart => _cart;

  /// Method to update the reference to the AuthProvider
  void updateWithAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    // You may want to perform additional updates or fetches here
    notifyListeners();
  }

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
  Future<void> addToCart(Item item, ItemSize size, int quantity) async {
    final Uri url = Uri.parse(
      '$apiUrl/carts',
    );
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'itemId': item.id!,
          'quantity': quantity,
          'size': size.name.toUpperCase(),
        }),
      );

      if (response.statusCode == 200) {
        _cart.add(
          CartItem(
            item: item,
            quantity: quantity,
            size: size,
          ),
        );
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to add to cart');
    }
  }
}
