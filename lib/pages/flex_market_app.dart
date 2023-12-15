import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/pages/cart.dart';
import 'package:flex_market/pages/hero.dart';
import 'package:flex_market/pages/home.dart';
import 'package:flex_market/pages/newpage.dart';
import 'package:flex_market/pages/search_page.dart';
import 'package:flex_market/pages/user.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represents an item in the navigation bar of the application.
class NavigationItem {
  /// Constructs a [NavigationItem] with the given [page], [icon], and [label].
  NavigationItem({required this.page, required this.icon, required this.label});

  /// The page to navigate to when this item is tapped.
  final Widget page;

  /// The icon representing this navigation item.
  final Widget icon;

  /// The label text for this navigation item.
  final String label;
}

/// The main application widget for FlexMarket.
///
/// This class manages the navigation and layout of the main screens
/// in the application, including home, search, favorites, cart, and user profile.
class FlexMarketApp extends StatefulWidget {
  /// Constructs a [FlexMarketApp] Widget.
  const FlexMarketApp({super.key});

  @override
  State<FlexMarketApp> createState() => _FlexMarketAppState();
}

class _FlexMarketAppState extends State<FlexMarketApp> {
  int _currentIndex = 0;

  late final List<NavigationItem> navbarPages = <NavigationItem>[
    NavigationItem(
      page: const HomeWidget(),
      icon: Image.asset(
        'assets/home.png',
        height: 22,
        width: 22,
      ),
      label: 'Home',
    ),
    NavigationItem(
      page: const SearchPageWidget(),
      icon: Image.asset(
        'assets/search.png',
        height: 22,
        width: 22,
      ),
      label: 'Search',
    ),
    NavigationItem(
      page: const NewPageWidget(),
      icon: Image.asset(
        'assets/fav.png',
        height: 22,
        width: 22,
      ),
      label: 'Favorites',
    ),
    NavigationItem(
      page: const CartWidget(),
      icon: Image.asset(
        'assets/cart.png',
        height: 22,
        width: 22,
      ),
      label: 'Cart',
    ),
    NavigationItem(
      page: const UserWidget(),
      icon: Image.asset(
        'assets/profile.png',
        height: 22,
        width: 22,
      ),
      label: 'Profile',
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final UserProfile? user = dataProvider.user;

    if (user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const HeroWidget(),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.90,
              child: navbarPages[_currentIndex].page,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFF3D3D3B)),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onItemTapped,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFFFF8E26),
              fill: 1,
              size: 24,
            ),
            unselectedIconTheme: const IconThemeData(
              size: 24,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            selectedItemColor: const Color(0xFFFF8E26),
            items: navbarPages
                .asMap()
                .map(
                  (int index, NavigationItem item) =>
                      MapEntry<int, BottomNavigationBarItem>(
                    index,
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: _currentIndex == index
                            ? BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFF8E26),
                                  width: 2,
                                ),
                                color: const Color(0xFF3D3D3B),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: item.icon,
                      ),
                      label: item.label,
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      );
    }
  }
}
