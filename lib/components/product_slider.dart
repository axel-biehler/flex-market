import 'package:flex_market/models/item.dart';
import 'package:flex_market/models/product.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays a slider of products.
///
/// This widget creates a horizontal list of product cards, each card displaying
/// a product image, its price, and title. Each product card also includes an
/// option to add or remove the product from favorites.
///
/// The widget requires a [title] and [subtitle] to be provided, which are displayed
/// above the product slider.
class ProductSliderWidget extends StatelessWidget {
  /// Creates a [ProductSliderWidget].
  ///
  /// Requires [title] and [subtitle] strings to be provided.
  const ProductSliderWidget({
    required this.title,
    required this.subtitle,
    required this.items,
    super.key,
  });

  /// The title text displayed above the product list.
  final String title;

  /// The subtitle text displayed below the title.
  final String subtitle;

  /// The products contained in the slider.
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: margin, left: margin / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: margin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final Item item = items[index];
                return Card(
                  color: Theme.of(context).primaryColor,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // if (item.imagesUrl.isNotEmpty)
                          Image.asset(
                            // item.imagesUrl.first,
                            'assets/shoes.png',
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            '\$${item.price.toString()}',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Positioned(
                        right: 7,
                        bottom: 15,
                        child: IconButton(
                          icon: SvgPicture.asset('assets/fav.svg', width: 40),
                          onPressed: () async => context.read<ItemProvider>().addToFavorites(item.id!),
                          highlightColor: Theme.of(context).colorScheme.secondary,
                        ),
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
