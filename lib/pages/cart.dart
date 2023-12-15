import 'package:flex_market/components/cart_products.dart';
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
        ],
      ),
    );
  }
}
