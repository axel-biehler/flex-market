import 'package:flex_market/pages/cart.dart';
import 'package:flex_market/pages/hero.dart';
import 'package:flex_market/pages/home.dart';
import 'package:flex_market/pages/item.dart';
import 'package:flex_market/pages/search_page.dart';
import 'package:flex_market/pages/user.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represents an item in the navigation bar of the application.
class NavigationItem {
  /// Constructs a [NavigationItem] with the given [navigatorKey], [pageBuilder],
  /// [page], [icon], and [label].
  NavigationItem({
    required this.navigatorKey,
    required this.pageBuilder,
    // required this.page,
    required this.icon,
    required this.label,
  });

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Page builder to pass the navigatorKey to its child
  final Widget Function(GlobalKey<NavigatorState>) pageBuilder;

  /// The page to navigate to when this item is tapped.
  // final Widget page;

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
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) => HomeWidget(navigatorKey: key),
      icon: Image.asset(
        'assets/home.png',
        height: 22,
        width: 22,
      ),
      label: 'Home',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) => SearchPageWidget(navigatorKey: key),
      icon: Image.asset(
        'assets/search.png',
        height: 22,
        width: 22,
      ),
      label: 'Search',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) => FavoritesWidget(navigatorKey: key),
      icon: Image.asset(
        'assets/fav.png',
        height: 22,
        width: 22,
      ),
      label: 'Favorites',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) => CartWidget(navigatorKey: key),
      icon: Image.asset(
        'assets/cart.png',
        height: 22,
        width: 22,
      ),
      label: 'Cart',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) => UserWidget(navigatorKey: key),
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

    if (context.watch<AuthProvider>().user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const HeroWidget(),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.87,
                child: IndexedStack(
                  index: _currentIndex,
                  children: navbarPages.map<Widget>((NavigationItem item) {
                    return Navigator(
                      key: item.navigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute<Widget>(builder: (BuildContext context) => item.pageBuilder(item.navigatorKey));
                      },
                    );
                  }).toList(),
                ),
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
        ),
      );
    }
  }
}
