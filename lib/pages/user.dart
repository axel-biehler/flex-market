import 'dart:async';

import 'package:flex_market/components/camera.dart';
import 'package:flex_market/models/user_profile.dart';
import 'package:flex_market/pages/admin/admin_items.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final String? pictureUrl = user?.picture;

    return Padding(
      padding: const EdgeInsets.all(padding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: margin),
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleLarge,
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
          Card(
            margin: const EdgeInsets.only(top: margin),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                UserEntryWidget(
                  propertyName: 'Name',
                  propertyValue: user?.name,
                ),
                UserEntryWidget(
                  propertyName: 'Email',
                  propertyValue: user?.email,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: margin),
              child: ElevatedButton(
                onPressed: () {
                  unawaited(
                    navigatorKey.currentState?.push(
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) =>
                            AdminItemsWidget(navigatorKey: navigatorKey),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Open admin items',
                  style: GoogleFonts.spaceGrotesk(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    height: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: margin),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await navigatorKey.currentState?.push(
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => CameraPage(
                            navigatorKey: navigatorKey,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Change profile picture',
                      style: GoogleFonts.spaceGrotesk(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        height: 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: context.read<AuthProvider>().logout,
                    child: Text(
                      'Logout',
                      style: GoogleFonts.spaceGrotesk(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        height: 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
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
