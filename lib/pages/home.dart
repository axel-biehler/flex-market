import 'package:flex_market/components/ProductSlider.dart';
import 'package:flutter/material.dart';

final Shader linearGradient = const LinearGradient(
        colors: <Color>[Color.fromRGBO(255, 79, 64, 100), Color.fromRGBO(255, 68, 221, 100)], begin: Alignment.topLeft, end: Alignment.bottomRight)
    .createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 70.0));

const sections = [
  ProductSliderWidget(title: 'Latest drop', subtitle: 'Discover our newest products'),
  ProductSliderWidget(title: 'Last offers', subtitle: 'Discover our products on sale and get a good deal'),
  ProductSliderWidget(title: 'Best sellers', subtitle: 'Top-selling items on Flex Market')
];

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [...sections.map((section) => section)],
      ),
    );
  }
}
