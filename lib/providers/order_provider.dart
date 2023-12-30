import 'dart:async';
import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/models/order.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Manages order-related state within the application.
class OrderProvider extends ChangeNotifier {
  /// Constructor that receives the AuthProvider
  OrderProvider(this.authProvider) {
    unawaited(fetchAllOrders());
    unawaited(fetchMyOrders());
  }

  /// Reference to the AuthProvider
  AuthProvider authProvider;

  /// List of all orders
  List<Order> orders = <Order>[];

  /// List of orders for the current user
  List<Order> myOrders = <Order>[];

  /// Method to update the reference to the AuthProvider
  void updateWithAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    notifyListeners();
  }

  /// Fetch all orders from the API
  Future<void> fetchAllOrders() async {
    final Uri url = Uri.parse('$apiUrl/orders/admin');

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
        final List<dynamic> jsonOrders = data['orders'] as List<dynamic>;
        orders = jsonOrders
            .map<Order>(
              (dynamic json) => Order.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifyListeners();
        if (kDebugMode) {
          print('Order data: $orders');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load orders');
    }
  }

  /// Fetch all orders for the current user from the API
  Future<void> fetchMyOrders() async {
    final Uri url = Uri.parse('$apiUrl/orders');

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
        final List<dynamic> jsonOrders = data['orders'] as List<dynamic>;
        myOrders = jsonOrders
            .map<Order>(
              (dynamic json) => Order.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifyListeners();
        if (kDebugMode) {
          print('Order data: $myOrders');
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to load orders');
    }
  }

  /// Create an order
  Future<bool> createOrder(CreateOrderDto order) async {
    final Uri url = Uri.parse('$apiUrl/orders');

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
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200) {
        unawaited(fetchAllOrders());
        unawaited(fetchMyOrders());
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
    return true;
  }

  /// Update the status of an order
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final Uri url = Uri.parse('$apiUrl/orders');

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
        body: jsonEncode(<String, String>{
          'orderId': orderId,
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        unawaited(fetchAllOrders());
        unawaited(fetchMyOrders());
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
    return true;
  }
}
