import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the items published by an admin vertically.
///
/// This widget creates a vertical list of product cards, each card displaying
/// a product image, its price, title and stock. Each product card also includes
/// a buttton to go to the product page.
class AdminItemsListWidget extends StatelessWidget {
  /// Creates a [AdminItemsListWidget].
  const AdminItemsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    if (context.watch<ItemProvider>().items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.77,
          child: ListView.builder(
            itemCount: context.watch<ItemProvider>().items.length,
            itemBuilder: (BuildContext context, int index) {
              final Item item = context.watch<ItemProvider>().items[index];
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
                                  'Stock: ${item.totalStock}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/arrow.svg', height: 40),
                          onPressed: () => print('add to cart'),
                          highlightColor: Theme.of(context).colorScheme.secondary,
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
    );
  }
}
