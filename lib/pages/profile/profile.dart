import 'dart:async';

import 'package:flex_market/models/user_profile.dart';
import 'package:flex_market/pages/admin/admin_items.dart';
import 'package:flex_market/pages/admin/admin_orders.dart';
import 'package:flex_market/pages/orders.dart';
import 'package:flex_market/pages/profile/edit_profile.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the user's profile information.
///
/// It shows the user's picture, name, email, and email verification status.
/// Additionally, it provides a logout button.
class UserWidget extends StatelessWidget {
  /// Creates a [UserWidget].
  const UserWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<AuthProvider>().userCustom;
    final String? pictureUrl = context.watch<AuthProvider>().userCustom?.picture.toString();
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
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: margin, left: margin / 2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'YOUR ACCOUNT',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                if (pictureUrl != null)
                  Container(
                    margin: const EdgeInsets.only(top: margin),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(pictureUrl.toString()),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  user?.nickname ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                    top: margin,
                    bottom: margin,
                    left: margin,
                  ),
                  child: const Text(
                    'Overview',
                    style: TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w200,
                      height: 0,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF3D3D3B)),
                      bottom: BorderSide(color: Color(0xFF3D3D3B)),
                    ),
                  ),
                  child: InkWell(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: margin,
                          ),
                          child: Text(
                            'Orders',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 2.40,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                    onTap: () {
                      unawaited(
                        navigatorKey.currentState?.push(
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => OrdersWidget(
                              navigatorKey: navigatorKey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                    top: margin,
                    bottom: margin,
                    left: margin,
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w200,
                      height: 0,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  width: 430,
                  height: 45,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF3D3D3B)),
                      bottom: BorderSide(color: Color(0xFF3D3D3B)),
                    ),
                  ),
                  child: InkWell(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: margin,
                          ),
                          child: Text(
                            'Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 2.40,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                    onTap: () {
                      unawaited(
                        navigatorKey.currentState?.push(
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => EditProfilePage(
                              navigatorKey: navigatorKey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (user?.isAdmin != null && user!.isAdmin == true)
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 26),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                          top: margin,
                          bottom: margin,
                          left: margin,
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            color: Color(0xFFC2C2C2),
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w200,
                            height: 0,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      Container(
                        width: 430,
                        height: 45,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF3D3D3B)),
                            bottom: BorderSide(color: Color(0xFF3D3D3B)),
                          ),
                        ),
                        child: InkWell(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: margin,
                                ),
                                child: Text(
                                  'Items',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: 2.40,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onTap: () {
                            unawaited(
                              navigatorKey.currentState?.push(
                                MaterialPageRoute<Widget>(
                                  builder: (BuildContext context) => AdminItemsWidget(
                                    navigatorKey: navigatorKey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 430,
                        height: 45,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF3D3D3B)),
                            bottom: BorderSide(color: Color(0xFF3D3D3B)),
                          ),
                        ),
                        child: InkWell(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: margin,
                                ),
                                child: Text(
                                  'Orders',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: 2.40,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onTap: () {
                            unawaited(
                              navigatorKey.currentState?.push(
                                MaterialPageRoute<Widget>(
                                  builder: (BuildContext context) => AdminOrdersWidget(
                                    navigatorKey: navigatorKey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a single entry of user information.
///
/// It shows a [propertyName] and its [propertyValue] side by side.
class UserEntryWidget extends StatelessWidget {
  /// Creates a [UserEntryWidget] with a given [propertyName] and [propertyValue].
  const UserEntryWidget({
    required this.propertyName,
    required this.propertyValue,
    super.key,
  });

  /// The name of the property to display (e.g., 'Name', 'Email').
  final String propertyName;

  /// The value of the property.
  final String? propertyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Text>[
          Text(
            propertyName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            propertyValue ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
