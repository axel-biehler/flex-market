import 'package:flex_market/models/item.dart';
import 'package:flex_market/pages/item.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 10,
                  childAspectRatio: (screenWidth * 0.5) / (screenHeight * 0.7 / 2.5),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (item.imagesUrl.isNotEmpty)
                                Image.asset(
                                  item.imagesUrl[0],
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
                            bottom: 80,
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
                          Positioned(
                            right: 7,
                            bottom: 30,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D3D3B),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                icon: Image.asset('assets/cart.png', width: 25),
                                onPressed: () async {
                                  final int quantity = context.read<CartProvider>().getItemQuantity(item.id!);
                                  await context.read<CartProvider>().addToCart(item, ItemSize.l, quantity + 1);
                                },
                                highlightColor: Theme.of(context).colorScheme.secondary,
                              ),
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
        ],
      ),
    );
  }
}
