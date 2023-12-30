import 'package:flex_market/components/image_viewer.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/pages/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the items marked as favorites vertically.
///
/// This widget creates a vertical list of item cards, each card displaying
/// a product image, its price, and title. Each item card also includes an
/// option to add or remove the product from favorites.
class FavoritesItemsWidget extends StatelessWidget {
  /// Creates a [FavoritesItemsWidget].
  const FavoritesItemsWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    const int crossAxisCount = 2;
    const double crossAxisSpacing = 40;
    final double cardWidth = (screenWidth - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;

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
                  'Your favorites',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Text(
                  '${context.watch<ItemProvider>().favorites.length.toString()} items',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              height: screenHeight * 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: margin),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: 10,
                    childAspectRatio: cardWidth / (screenHeight * 0.7 / 2.5),
                  ),
                  itemCount: context.watch<ItemProvider>().favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Item item = context.watch<ItemProvider>().favorites[index];
                    final bool isFav = context.watch<ItemProvider>().isFavorite(item.id!);

                    return InkWell(
                      onTap: () async {
                        await navigatorKey.currentState?.push(
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => ItemWidget(item: item),
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            SizedBox(
                              width: cardWidth,
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
                              top: 3,
                              left: 3,
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  isFav ? 'assets/fav-filled.svg' : 'assets/fav.svg',
                                  height: isFav ? 25 : 40,
                                ),
                                color: isFav ? Colors.red : null,
                                onPressed: () async => context.read<ItemProvider>().toggleFavorites(item.id!),
                                highlightColor: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
