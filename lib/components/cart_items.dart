import 'dart:async';

import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the items contained in the cart vertically.
///
/// This widget creates a vertical list of item cards, each card displaying
/// an item image, price, size, and name. Each item card also includes an
/// button to manage the quantity in the card.
class CartItemsWidget extends StatelessWidget {
  /// Creates a [CartItemsWidget].
  const CartItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(top: margin, left: margin / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Text>[
                    Text(
                      'YOUR CART',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      '${context.watch<CartProvider>().totalItemsInCart} items',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: margin),
                child: ElevatedButton(
                  onPressed: () {
                    unawaited(context.read<CartProvider>().emptyCart());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'EMPTY',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.6,
            child: ListView.builder(
              itemCount: context.watch<CartProvider>().cart.length,
              itemBuilder: (BuildContext context, int index) {
                final String itemId = context.watch<CartProvider>().cart[index].itemId;
                final ItemSize size = context.watch<CartProvider>().cart[index].size;
                final int quantity = context.watch<CartProvider>().cart[index].quantity;
                final Item? item = context.watch<ItemProvider>().getById(itemId);

                if (item == null) return null;

                return Card(
                  color: Theme.of(context).primaryColor,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (item.imagesUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(margin),
                              child: Image.asset(
                                item.imagesUrl[0],
                                width: 130,
                                height: 130,
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  '\$${item.price.toString()}',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: margin),
                                  child: Text(
                                    item.name,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: margin),
                                  child: Text(
                                    'Size: ${size.name.toUpperCase()}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              color: Color(0xFF3D3D3B),
                            ),
                            child: DropdownButton<int>(
                              value: quantity,
                              menuMaxHeight: 200,
                              icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.secondary),
                              onChanged: (int? newValue) async {
                                await context.read<CartProvider>().addToCart(item, size, newValue!);
                              },
                              items: List<int>.generate(25 + 101, (int i) => i).map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: margin / 2),
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    ),
                                  ),
                                );
                              }).toList(),
                              dropdownColor: Theme.of(context).primaryColor,
                              underline: Container(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
