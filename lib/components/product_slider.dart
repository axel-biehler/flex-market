import 'package:flex_market/components/image_viewer.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/pages/item.dart';
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
    required this.navigatorKey,
    required this.title,
    required this.subtitle,
    required this.items,
    super.key,
  });

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// The title text displayed above the product list.
  final String title;

  /// The subtitle text displayed below the title.
  final String subtitle;

  /// The products contained in the slider.
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
                final bool isFav = context.watch<ItemProvider>().isFavorite(item.id!);

                return InkWell(
                  onTap: () async {
                    await navigatorKey.currentState?.push(
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => ItemWidget(item: item),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: margin / 2),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          SizedBox(
                            width: screenWidth * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (item.imagesUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    child: ImageViewerWidget(
                                      url: item.imagesUrl.first,
                                    ),
                                  ),
                                Text(
                                  '\$${item.price.toString()}',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 3,
                            top: 3,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                isFav ? 'assets/fav-filled.svg' : 'assets/fav.svg',
                                height: isFav ? 25 : 40,
                              ),
                              onPressed: () async => context.read<ItemProvider>().toggleFavorites(item.id!),
                              highlightColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
