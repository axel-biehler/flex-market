import 'dart:async';
import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/models/add_pics_response.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/models/search_query.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  /// Items available on the store
  List<Item> items = <Item>[];

  /// User's favorite items
  List<Item> favorites = <Item>[];

  /// Checks if a given item is in favorites
  bool isFavorite(String itemId) {
    return favorites.any((Item item) => item.id == itemId);
  }

  /// Getter to return an item by Id
  Item? getById(String itemId) {
    return items.firstWhere((Item? e) => e?.id == itemId);
  }

  /// Getter to return items grouped by category
  Map<String, List<Item>> get itemsByCategory {
    final Map<String, List<Item>> groupedItems = groupBy<Item, String>(items, (Item item) => item.category);
    final List<MapEntry<String, List<Item>>> sortedEntries = groupedItems.entries.toList()
      ..sort(
        (MapEntry<String, List<Item>> a, MapEntry<String, List<Item>> b) => b.value.length.compareTo(a.value.length),
      );

    return Map<String, List<Item>>.fromEntries(sortedEntries);
  }

  /// Helper function to group items by a specific key
  Map<K, List<V>> groupBy<V, K>(Iterable<V> values, K Function(V) keyFunction) {
    final Map<K, List<V>> map = <K, List<V>>{};
    for (final V element in values) {
      final K key = keyFunction(element);
      map.putIfAbsent(key, () => <V>[]).add(element);
    }
    return map;
  }

  /// Method to update the reference to the AuthProvider
  void updateWithAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    notifyListeners();
  }

  /// Method to filter items based on the gender
  bool matchesGender(SearchPageGender toMatch, String strGender) {
    final ItemGender? gender = stringToGender(strGender);
    if (gender == null) {
      return true;
    } else if (toMatch == SearchPageGender.all || gender == ItemGender.unisex) {
      return true;
    } else if (toMatch.name == gender.name) {
      return true;
    } else {
      return false;
    }
  }

  /// Method to get a list of items filtered with a [SearchQuery] object.
  List<Item> getFilteredItems(SearchQuery query) {
    final Iterable<Item> genderFiltered = items.where((Item item) => matchesGender(query.gender, item.gender));
    final Iterable<Item> categoryFiltered =
        genderFiltered.where((Item item) => query.categories.isEmpty || query.categories.contains(stringToItemCategory(item.category)));
    return categoryFiltered.where((Item item) => item.name.toLowerCase().contains(query.query.toLowerCase())).toList();
  }

  /// Fetch all products from the API
  Future<void> fetchAllProducts() async {
    final Uri url = Uri.parse(
      '$apiUrl/products',
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
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> jsonItems = data['products'] as List<dynamic>;
        items = jsonItems
            .map<Item>(
              (dynamic json) => Item.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifyListeners();
        unawaited(fetchFavorites());
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

  /// Fetch user favorite items
  Future<void> fetchFavorites() async {
    final Uri url = Uri.parse(
      '$apiUrl/favorites',
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
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> jsonItems = data['items'] as List<dynamic>;
        favorites = jsonItems
            .map<Item>(
              (dynamic json) => items.firstWhere((Item e) => e.id == json['itemId']),
            )
            .toList();
        notifyListeners();
        if (kDebugMode) {
          print('Favorites: $favorites');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load favorites');
    }
  }

  /// Add or remove and item from the favorites depending on its current status
  Future<bool> toggleFavorites(String id) async {
    final Uri url = Uri.parse(
      '$apiUrl/favorites',
    );
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      http.Response response;

      if (isFavorite(id)) {
        response = await http.patch(
          url,
          headers: <String, String>{
            'Authorization': 'Bearer ${credentials.accessToken}',
          },
          body: jsonEncode(<String, String>{
            'itemId': id,
            'size': 'L',
          }),
        );
      } else {
        response = await http.post(
          url,
          headers: <String, String>{
            'Authorization': 'Bearer ${credentials.accessToken}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'itemId': id,
            'size': 'L',
          }),
        );
      }

      if (response.statusCode == 200) {
        await fetchFavorites();
        return true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to add to favorites');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to add to favorites');
    }
  }

  /// Create an item
  Future<List<dynamic>> createItem(Item item) async {
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
        unawaited(fetchAllProducts());
        final dynamic data = json.decode(response.body);
        final List<dynamic> presignedUrls = data['presignedUrls'];
        return presignedUrls;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to create product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to create product');
    }
  }

  /// Update an item
  Future<bool> updateItem(Item item) async {
    final Uri url = Uri.parse(
      '$apiUrl/products/${item.id}',
    );
    final Credentials? credentials = authProvider.credentials;
    if (credentials == null) {
      throw Exception('No credentials available. User must be logged in.');
    }

    try {
      final http.Response response = await http.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
        body: item.toJson(),
      );

      if (response.statusCode == 200) {
        unawaited(fetchAllProducts());
        return true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to update product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to update product');
    }
  }

  /// Delete an item
  Future<bool> deleteItem(Item item) async {
    final Uri url = Uri.parse(
      '$apiUrl/products/${item.id}',
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
        },
      );

      if (response.statusCode == 200) {
        unawaited(fetchAllProducts());
        return true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to update product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to update product');
    }
  }

  /// Fetches a product by its ID from a specified API endpoint and handles the response.
  Future<Item> fetchProductById(
    String productId,
  ) async {
    final Uri url = Uri.parse(
      '$apiUrl/products/$productId',
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
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

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

  /// Get an array of presigned urls used to upload pictures
  Future<AddPicsResponse> getPresignedUrls(List<XFile> pictures, String productId) async {
    final Uri url = Uri.parse(
      '$apiUrl/products/$productId',
    );
    final List<String> picsNames = pictures.map((XFile e) => e.name).toList();

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
        body: jsonEncode(<String, dynamic>{
          'imagesUrl': picsNames,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<String> presignedUrls = List<String>.from(data['presignedUrls']);
        final List<String> imageUrls = List<String>.from(data['imageUrls']);
        if (kDebugMode) {
          print('Add pictures data: $data');
        }
        return AddPicsResponse(
          presignedUrls: presignedUrls,
          imageUrls: imageUrls,
        );
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to add pictures');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to add pictures');
    }
  }
}
