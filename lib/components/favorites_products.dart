import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the products market as favorites vertically.
///
/// This widget creates a vertical list of product cards, each card displaying
/// a product image, its price, and title. Each product card also includes an
/// option to add or remove the product from favorites.
class FavoritesProductsWidget extends StatelessWidget {
  /// Creates a [FavoritesProductsWidget].
  const FavoritesProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final List<Product> products = dataProvider.mockProducts;
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
                  '45 items',
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
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 50, // Spacing between items on the cross axis
                  mainAxisSpacing: 10, // Spacing between items on the main axis
                  childAspectRatio: (screenWidth * 0.5) / (screenHeight * 0.7 / 2.5), // Aspect ratio for each item
                ),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product product = products[index];
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              product.imageUrl,
                              width: 150,
                              height: 150,
                            ),
                            Text(
                              '\$${product.price.toString()}',
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            Text(
                              product.title,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Positioned(
                          right: 7,
                          bottom: 15,
                          child: IconButton(
                            icon: SvgPicture.asset('assets/fav.svg', width: 40),
                            onPressed: () => dataProvider.addToCart(product),
                            highlightColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
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
