import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// A widget that displays the user's profile information.
///
/// It shows the user's picture, name, email, and email verification status.
/// Additionally, it provides a logout button.
class UserWidget extends StatelessWidget {
  /// Creates a [UserWidget].
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataProvider authProvider = Provider.of<DataProvider>(context);
    final UserProfile? user = authProvider.user;
    final Uri? pictureUrl = user?.pictureUrl;

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
              child: CircleAvatar(
                radius: 56,
                child: ClipOval(child: Image.network(pictureUrl.toString())),
              ),
            ),
          Card(
            margin: const EdgeInsets.only(top: margin),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                UserEntryWidget(propertyName: 'Name', propertyValue: user?.name),
                UserEntryWidget(propertyName: 'Email', propertyValue: user?.email),
                UserEntryWidget(propertyName: 'Email Verified', propertyValue: user?.isEmailVerified == true ? 'Yes' : 'No'),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: margin),
              child: ElevatedButton(
                onPressed: authProvider.logout,
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
  const UserEntryWidget({required this.propertyName, required this.propertyValue, super.key});

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
