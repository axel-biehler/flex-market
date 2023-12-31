import 'dart:async';
import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/models/cart_item.dart';
import 'package:flex_market/models/item.dart';
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
  CartProvider(this.authProvider) {
    unawaited(fetchCart());
  }

  /// Reference to the AuthProvider
  AuthProvider authProvider;

  /// The shopping cart containing a list of [CartItem].
  final List<CartItem> _cart = <CartItem>[];

  /// The shopping cart total price.
  double _cartPrice = 0;

  /// Getter for the user's cart.
  List<CartItem> get cart => _cart;

  /// Getter for the user's cart price.
  double get cartPrice => _cartPrice;

  /// Getter for the user's cart number of items.
  int get totalItemsInCart {
    return _cart.fold(0, (int sum, CartItem item) => sum + item.quantity);
  }

  /// Getter to get the quantity of an item.
  int getItemQuantity(String id) {
    final int cartEntryIdx = _cart.indexWhere((CartItem e) => e.itemId == id);
    return cartEntryIdx != -1 ? _cart[cartEntryIdx].quantity : 0;
  }

  /// Method to update the reference to the AuthProvider
  void updateWithAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    notifyListeners();
  }

  /// Fetch items in the cart
  Future<void> fetchCart() async {
    final Uri url = Uri.parse(
      '$apiUrl/carts',
    );
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        final List<dynamic> items = data['items'];
        _cartPrice = data['totalAmount'].toDouble();
        _cart.clear();
        for (final dynamic item in items) {
          _cart.add(
            CartItem(
              itemId: item['itemId'],
              quantity: item['quantity'],
              size: stringToSize(item['size'])!,
            ),
          );
        }
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to fetch the cart');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to fetch the cart');
    }
  }

  /// Adds a item to the shopping cart and notifies listeners.
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
            itemId: item.id!,
            quantity: quantity,
            size: size,
          ),
        );
        await fetchCart();
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

  /// Empty the user's shopping cart.
  Future<void> emptyCart() async {
    final Uri url = Uri.parse(
      '$apiUrl/carts',
    );
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _cart.clear();
        _cartPrice = 0;
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to empty cart');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to empty cart');
    }
  }
}
