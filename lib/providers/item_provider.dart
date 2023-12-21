import 'dart:async';
import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Manages the application state including user authentication,
/// product data, and shopping cart functionality.
///
/// This class acts as a central hub for the state management within
/// the application, leveraging Flutter's Provider package for state
/// notification and updates.
class ItemProvider extends ChangeNotifier {
  /// Constructor that receives the AuthProvider
  ItemProvider(this.authProvider) {
    items = <Item>[];
    unawaited(fetchAllProducts());
  }

  /// Reference to the AuthProvider
  AuthProvider authProvider;

  /// The URL for the API endpoint.
  final String apiUrl = dotenv.env['API_URL']!;

  /// Items available on the store
  List<Item> items = <Item>[];

  /// Method to update the reference to the AuthProvider
  void updateWithAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    // You may want to perform additional updates or fetches here
    notifyListeners();
  }

  /// Fetch all products from the API
  Future<void> fetchAllProducts() async {
    final Uri url = Uri.parse(
      '$apiUrl/products',
    );

    // Retrieve credentials from AuthProvider
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> jsonItems = data['products'] as List<dynamic>;
        items = jsonItems.map<Item>((dynamic json) => Item.fromJson(json as Map<String, dynamic>)).toList();
        notifyListeners();
        if (kDebugMode) {
          print('Product data: $items');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load product');
    }
  }

  /// Create a product
  Future<bool> createProduct(Item item) async {
    final Uri url = Uri.parse(
      '$apiUrl/products',
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
        },
        body: item.toJson(),
      );

      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
        return true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load product');
    }
  }

  /// Fetches a product by its ID from a specified API endpoint and handles the response.
  Future<Item> fetchProductById(
    String productId,
  ) async {
    final Uri url = Uri.parse(
      '$apiUrl/products/$productId',
    );

    // Retrieve credentials from AuthProvider
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Convert the JSON response into a Product object.
        final Item item = Item.fromJson(data['product']);
        if (kDebugMode) {
          print('Product data: $item');
        }
        return item;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load product');
    }
  }
}
