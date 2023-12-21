import 'package:flex_market/components/product_slider.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

/// A custom linear gradient shader used for text styling.
final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color.fromRGBO(255, 79, 64, 100), Color.fromRGBO(255, 68, 221, 100)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
).createShader(const Rect.fromLTWH(0, 0, 500, 70));

/// The home screen widget for the FlexMarket application.
///
/// This widget presents a scrollable view of different product sliders,
/// showcasing various categories like the latest products, offers, and best sellers.
class HomeWidget extends StatelessWidget {
  /// Creates a [HomeWidget].
  const HomeWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Map<String, List<Item>> items = context.watch<ItemProvider>().itemsByCategory;

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
          ...items.entries.map((MapEntry<String, List<Item>> entry) {
            return ProductSliderWidget(
              title: entry.key,
              subtitle: 'Discover our ${entry.key.toLowerCase()}',
              items: entry.value,
            );
          }),
        ],
      ),
    );
  }
}
