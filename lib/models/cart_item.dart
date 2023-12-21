import 'package:flex_market/models/item.dart';
import 'package:flex_market/utils/enums.dart';

/// Represents an item contained in the cart with an item, quantity and size.
class CartItem {
  /// Creates a [CartItem] with the given [item], [quantity] and [size].
  CartItem({
    required this.item,
    required this.quantity,
    required this.size,
  });

  /// Item object.
  final Item item;

  /// Quantity
  final int quantity;

  /// Size of the item.
  final ItemSize size;
}
