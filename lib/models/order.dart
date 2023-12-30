import 'dart:convert';

import 'package:flex_market/utils/enums.dart';

/// Represents an order with orderId, userId, items, totalAmount, orderDate, status, and shippingAddress
class Order {
  /// Creates an [Order] with the given [orderId], [userId], [items], [totalAmount], [orderDate], [status], and [shippingAddress].
  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });

  /// Returns an [Order] from the given [json] map.
  factory Order.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson =
        json['items'] as List<dynamic>; // Cast as List<dynamic>
    final List<OrderItem> itemsList = itemsJson.map((dynamic itemJson) {
      return OrderItem.fromJson(
        itemJson as Map<String, dynamic>,
      );
    }).toList();

    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      items: itemsList,
      totalAmount: json['totalAmount'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
      shippingAddress: json['shippingAddress'],
    );
  }

  /// Returns a JSON String from the Order object
  String toJson() {
    return jsonEncode(<String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'items': items.map((OrderItem x) => x.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'shippingAddress': shippingAddress,
    });
  }

  /// id of the order.
  final String orderId;

  /// id of the user who made the order.
  final String userId;

  /// List of items in the order.
  final List<OrderItem> items;

  /// Total amount of the order.
  final double totalAmount;

  /// Date when the order was placed.
  final DateTime orderDate;

  /// Status of the order.
  final String status;

  /// Shipping address for the order.
  final String shippingAddress;
}

/// Represents an item in an order with itemId, quantity, and price
class OrderItem {
  /// Creates an [OrderItem] with the given [itemId], [quantity], [price] and [size].
  OrderItem({
    required this.itemId,
    required this.quantity,
    required this.size,
  });

  /// Returns an [OrderItem] from the given [json] map.
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['itemId'],
      quantity: json['quantity'],
      size: stringToSize(json['size'])!,
    );
  }

  /// Returns a JSON String from the OrderItem object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'itemId': itemId,
      'quantity': quantity,
      'size': sizeToString(size),
    };
  }

  /// id of the item in the order.
  final String itemId;

  /// Quantity of the item ordered.
  final int quantity;

  /// Size of the item.
  final ItemSize size;
}

/// Represents an order with items and shippingAddress
class CreateOrderDto {
  /// Creates an [CreateOrderDto] with the given [items] and [shippingAddress].
  CreateOrderDto({
    required this.items,
    required this.shippingAddress,
  });

  /// Returns an [CreateOrderDto] from the given [json] map.
  factory CreateOrderDto.fromJson(Map<String, dynamic> json) {
    return CreateOrderDto(
      items: List<OrderItem>.from(json['items'].map(OrderItem.fromJson)),
      shippingAddress: json['shippingAddress'],
    );
  }

  /// Returns a JSON String from the CreateOrderDto object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((OrderItem item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress,
    };
  }

  /// List of items in the order.
  final List<OrderItem> items;

  /// Shipping address for the order.
  final String shippingAddress;
}
