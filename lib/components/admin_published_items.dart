import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flex_market/utils/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the items published by an admin vertically.
///
/// This widget creates a vertical list of product cards, each card displaying
/// a product image, its price, title and stock. Each product card also includes
/// a buttton to go to the product page.
class AdminPublishedItemsWidget extends StatelessWidget {
  /// Creates a [AdminPublishedItemsWidget].
  const AdminPublishedItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = context.watch<DataProvider>().mockProducts;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.77,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = products[index];
              return Card(
                color: Theme.of(context).primaryColor,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(margin),
                          child: Image.asset(
                            product.imageUrl,
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
                                '\$${product.price.toString()}',
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: margin),
                                child: Text(
                                  product.title,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: margin),
                                child: Text(
                                  'Size: ${product.size.name.toUpperCase()}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/arrow.svg', height: 40),
                          onPressed: () => context.read<DataProvider>().addToCart(product),
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
