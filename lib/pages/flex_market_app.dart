import 'dart:async';

import 'package:flex_market/pages/cart.dart';
import 'package:flex_market/pages/favorites.dart';
import 'package:flex_market/pages/hero.dart';
import 'package:flex_market/pages/home.dart';
import 'package:flex_market/pages/profile/profile.dart';
import 'package:flex_market/pages/search/search_page.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NavigationItem {
  NavigationItem({
    required this.navigatorKey,
    required this.pageBuilder,
    required this.iconPath,
    required this.label,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget Function(GlobalKey<NavigatorState>) pageBuilder;
  final String iconPath;
  final String label;
}

class FlexMarketApp extends StatefulWidget {
  const FlexMarketApp({super.key});

  @override
  State<FlexMarketApp> createState() => _FlexMarketAppState();
}

class _FlexMarketAppState extends State<FlexMarketApp> {
  int _currentIndex = 0;

  late final List<NavigationItem> navbarPages = <NavigationItem>[
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) =>
          HomeWidget(navigatorKey: key),
      iconPath: 'assets/svg/home.svg',
      label: 'Home',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) =>
          SearchPageWidget(navigatorKey: key),
      iconPath: 'assets/svg/search.svg',
      label: 'Search',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) =>
          FavoritesWidget(navigatorKey: key),
      iconPath: 'assets/svg/fav.svg',
      label: 'Favorites',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) =>
          CartWidget(navigatorKey: key),
      iconPath: 'assets/svg/cart.svg',
      label: 'Cart',
    ),
    NavigationItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      pageBuilder: (GlobalKey<NavigatorState> key) =>
          UserWidget(navigatorKey: key),
      iconPath: 'assets/svg/profile.svg',
      label: 'Profile',
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(initializeAuth());
  }

  Future<void> initializeAuth() async {
    await context.read<AuthProvider>().initWebAuth();
  }

  Widget _buildIcon(NavigationItem item, bool isSelected) {
    return Container(
      width: 35, // Slightly increased size for the border
      height: 35, // Slightly increased size for the border
      padding:
          const EdgeInsets.all(6), // Adjust the padding inside the container
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.transparent, // Ensure the background is transparent
              border: Border.all(
                color: const Color(0xFFFF8E26), // Border color
                width: 2, // Border width
              ),
              borderRadius: BorderRadius.circular(8), // Border radius
            )
          : null,
      child: SvgPicture.asset(
        item.iconPath,
        color: isSelected ? const Color(0xFFFF8E26) : Colors.white,
        width: 22, // Set your SVG image width
        height: 22, // Set your SVG image height
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    if (context.watch<AuthProvider>().user == null &&
        context.watch<AuthProvider>().isAuthenticated == false) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (context.watch<AuthProvider>().user == null &&
        context.watch<AuthProvider>().isAuthenticated == null) {
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
              Expanded(
                child: SizedBox(
                  height: screenHeight * 0.87,
                  child: IndexedStack(
                    index: _currentIndex,
                    children: navbarPages.map<Widget>((NavigationItem item) {
                      return Navigator(
                        key: item.navigatorKey,
                        onGenerateRoute: (RouteSettings settings) {
                          return MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                item.pageBuilder(item.navigatorKey),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: const NavigationBarThemeData(
                indicatorColor: Colors.transparent,
              ),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: onItemTapped,
              height: 60,
              backgroundColor: const Color(0xFF121212), // Background color
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: navbarPages.map((NavigationItem item) {
                final bool isSelected =
                    _currentIndex == navbarPages.indexOf(item);
                return NavigationDestination(
                  icon: _buildIcon(item, false),
                  selectedIcon: _buildIcon(item, true),
                  label: item.label,
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
  }
}
