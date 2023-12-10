import 'package:flutter/material.dart';

/// A widget that displays the user's shopping cart.
///
/// It presents a scrollable list of items that the user has added to their cart.
class CartWidget extends StatelessWidget {
  /// Creates a [CartWidget].
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'Cart',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
        ],
      ),
    );
  }
}
