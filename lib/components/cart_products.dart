import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the products market as favorites vertically.
///
/// This widget creates a vertical list of product cards, each card displaying
/// a product image, its price, and title. Each product card also includes an
/// option to add or remove the product from favorites.
class CartProductsWidget extends StatelessWidget {
  /// Creates a [CartProductsWidget].
  const CartProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final List<Product> products = dataProvider.mockProducts;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                  'YOUR CART',
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
          SizedBox(
            height: screenHeight * 0.6,
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
                          Container(
                            margin: const EdgeInsets.only(top: margin),
                            decoration: BoxDecoration(
                              border: Border.all(
                                // color: Theme.of(context).colorScheme.secondary,
                                color: const Color(0xFF3D3D3B), // Text color
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              // color: const Color(0xFF3D3D3B),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  color: Color(0xFF3D3D3B), // Text color
                                ),
                                child: DropdownButton<int>(
                                  value: 25,
                                  menuMaxHeight: 200,
                                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.secondary),
                                  onChanged: (int? newValue) {
                                    // TODO(arobine): Handle quantity edit.
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
                                    color: Theme.of(context).colorScheme.secondary, // Text color
                                  ),
                                ),
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
