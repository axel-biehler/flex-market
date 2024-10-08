import 'package:flex_market/components/cart_items.dart';
import 'package:flex_market/models/cart_item.dart';
import 'package:flex_market/models/order.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/providers/order_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the user's shopping cart.
///
/// It presents a scrollable list of items that the user has added to their cart.
class CartWidget extends StatefulWidget {
  /// Creates a [CartWidget].
  const CartWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  CartWidgetState createState() => CartWidgetState();
}

/// State for [CartWidget].
class CartWidgetState extends State<CartWidget> {
  /// Simulate the order processing
  Future<void> order(BuildContext context) async {
    try {
      final CreateOrderDto order = CreateOrderDto(
        items: context
            .read<CartProvider>()
            .cart
            .map(
              (CartItem item) => OrderItem(
                itemId: item.itemId,
                quantity: item.quantity,
                size: item.size,
              ),
            )
            .toList(),
        shippingAddress: 'la beuh',
      );

      await context.read<OrderProvider>().createOrder(order);

      if (mounted) {
        await context.read<CartProvider>().emptyCart();
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Success',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              content: Text(
                'Order placed successfully.',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xFF247100)),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Failed to empty cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.10,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3B),
                ),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.60,
                child: SvgPicture.asset('assets/homebanner.svg'),
              ),
            ),
          ),
          const CartItemsWidget(),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 29,
                  ),
                  child: Text(
                    'Total:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 9,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.45,
                    child: Text(
                      '\$${context.watch<CartProvider>().cartPrice}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 24,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: margin),
                  child: ElevatedButton(
                    onPressed: () async => order(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF247100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ORDER',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
