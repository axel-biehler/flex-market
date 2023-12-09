import 'package:flex_market/pages/home.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import 'hero.dart';
import 'user.dart';

class NavigationItem {
  final Widget page;
  final Widget icon;
  final String label;

  NavigationItem({required this.page, required this.icon, required this.label});
}

class FlexMarketApp extends StatefulWidget {
  const FlexMarketApp({super.key});

  @override
  State<FlexMarketApp> createState() => _FlexMarketAppState();
}

class _FlexMarketAppState extends State<FlexMarketApp> {
  int _currentIndex = 0;

  late final List<NavigationItem> navbarPages = [
    NavigationItem(page: const HomeWidget(), icon: Image.asset('assets/home.png'), label: 'Home'),
    NavigationItem(page: const HeroWidget(), icon: Image.asset('assets/search.png'), label: 'Search'),
    NavigationItem(page: const HeroWidget(), icon: Image.asset('assets/fav.png'), label: 'Favorites'),
    NavigationItem(page: const HeroWidget(), icon: Image.asset('assets/cart.png'), label: 'Cart'),
    NavigationItem(page: const UserWidget(), icon: Image.asset('assets/profile.png'), label: 'Profile'),
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<DataProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(backgroundColor: Theme.of(context).primaryColor, body: const HeroWidget());
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Container(
              height: screenHeight * 0.12,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF3D3D3B),
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: screenWidth * 0.60,
                  child: SvgPicture.asset('assets/homebanner.svg', fit: BoxFit.contain),
                ),
              ),
            ),
            navbarPages[_currentIndex].page,
          ],
        ),
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFF3D3D3B), width: 1),
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
                .map((index, item) => MapEntry(
                      index,
                      BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: _currentIndex == index
                              ? BoxDecoration(
                                  border: Border.all(color: const Color(0xFFFF8E26), width: 2),
                                  color: const Color(0xFF3D3D3B),
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : null,
                          child: item.icon,
                        ),
                        label: item.label,
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
      );
    }
  }
}
