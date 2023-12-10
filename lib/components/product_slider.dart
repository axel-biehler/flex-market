import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A custom linear gradient shader used for text styling.
final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color.fromRGBO(255, 79, 64, 100), Color.fromRGBO(255, 68, 221, 100)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
).createShader(const Rect.fromLTWH(0, 0, 500, 70));

/// A widget that displays a slider of products.
///
/// This widget creates a horizontal list of product cards, each card displaying
/// a product image, its price, and title. Each product card also includes an
/// 'add to cart' button.
///
/// The widget requires a [title] and [subtitle] to be provided, which are displayed
/// above the product slider.
class ProductSliderWidget extends StatelessWidget {
  /// Creates a [ProductSliderWidget].
  ///
  /// Requires [title] and [subtitle] strings to be provided.
  const ProductSliderWidget({required this.title, required this.subtitle, super.key});

  /// The title text displayed above the product list.
  final String title;

  /// The subtitle text displayed below the title.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final List<Product> products = dataProvider.mockProducts;

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
                        right: 5,
                        bottom: 45,
                        child: IconButton(
                          icon: SvgPicture.asset('assets/add-to-cart.svg', width: 40),
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
        ],
      ),
    );
  }
}
