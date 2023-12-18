import 'package:flex_market/components/cart_products.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays the user's shopping cart.
///
/// It presents a scrollable list of items that the user has added to their cart.
class CartWidget extends StatelessWidget {
  /// Creates a [CartWidget].
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.10,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3B),
                ),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.60,
                child: SvgPicture.asset('assets/homebanner.svg'),
              ),
            ),
          ),
          const CartProductsWidget(),
          SizedBox(
            height: screenHeight * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 29,
                  ),
                  child: Text(
                    'Total:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 9,
                  ),
                  child: Text(
                    r'$245,90',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: margin),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO(arobine): Clear the cart and notify the user that the order has been processed.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF247100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ORDER',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
