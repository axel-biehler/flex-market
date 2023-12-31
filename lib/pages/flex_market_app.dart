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

/// Navigation item model
class NavigationItem {
  /// Creates a new [NavigationItem]
  NavigationItem({
    required this.navigatorKey,
    required this.pageBuilder,
    required this.iconPath,
    required this.label,
  });

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// Page builder used to create the page
  final Widget Function(GlobalKey<NavigatorState>) pageBuilder;

  /// Path to the icon
  final String iconPath;

  /// Label of the item
  final String label;
}

/// FlexMarketApp component
class FlexMarketApp extends StatefulWidget {
  /// Creates a new [FlexMarketApp]
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
    final double iconSize = isSelected ? 26 : 22;
    const double borderSize = 2;
    final double padding = isSelected ? 12 : 10;

    return Container(
      width: iconSize + padding * 2,
      height: iconSize + padding * 2,
      padding: EdgeInsets.all(padding),
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(
                0xFF3D3D3B,
              ),
              border: Border.all(
                color: const Color(0xFFFF8E26),
                width: borderSize,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: SvgPicture.asset(
        item.iconPath,
        colorFilter: isSelected
            ? const ColorFilter.mode(Color(0xFFFF8E26), BlendMode.srcIn)
            : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        width: iconSize,
        height: iconSize,
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
            ],
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF3D3D3B), width: 3),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  indicatorColor: Colors.transparent,
                  backgroundColor: Theme.of(context).primaryColor,
                  surfaceTintColor: Colors.transparent,
                  height: screenHeight * 0.10,
                  shadowColor: Colors.transparent,
                ),
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: onItemTapped,
                height: screenHeight * 0.10,
                backgroundColor: Theme.of(context).primaryColor,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: navbarPages.map((NavigationItem item) {
                  return NavigationDestination(
                    icon: _buildIcon(item, false),
                    selectedIcon: _buildIcon(item, true),
                    label: item.label,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
