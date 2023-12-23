import 'package:flex_market/utils/enums.dart';

/// Represents an item contained in the cart with an item, quantity and size.
class CartItem {
  /// Creates a [CartItem] with the given [itemId], [quantity] and [size].
  CartItem({
    required this.itemId,
    required this.quantity,
    required this.size,
  });

  /// Item id string.
  final String itemId;

  /// Quantity
  final int quantity;

  /// Size of the item.
  final ItemSize size;
}
