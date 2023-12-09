import 'package:flex_market/components/product_slider.dart';
import 'package:flutter/material.dart';

/// A custom linear gradient shader used for text styling.
final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color.fromRGBO(255, 79, 64, 100), Color.fromRGBO(255, 68, 221, 100)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
).createShader(const Rect.fromLTWH(0, 0, 500, 70));

/// Predefined sections for the home screen, each representing a product slider.
const List<ProductSliderWidget> sections = <ProductSliderWidget>[
  ProductSliderWidget(title: 'Latest drop', subtitle: 'Discover our newest products'),
  ProductSliderWidget(title: 'Last offers', subtitle: 'Discover our products on sale and get a good deal'),
  ProductSliderWidget(title: 'Best sellers', subtitle: 'Top-selling items on Flex Market'),
];

/// The home screen widget for the FlexMarket application.
///
/// This widget presents a scrollable view of different product sliders,
/// showcasing various categories like the latest products, offers, and best sellers.
class HomeWidget extends StatelessWidget {
  /// Creates a [HomeWidget].
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[...sections.map((ProductSliderWidget section) => section)],
      ),
    );
  }
}
