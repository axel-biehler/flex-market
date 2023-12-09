import 'package:flex_market/utils/data_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<DataProvider>(context);
    final user = authProvider.user;
    final pictureUrl = user?.pictureUrl;

    return Padding(
      padding: const EdgeInsets.all(padding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              children: [
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
          )
        ],
      ),
    );
  }
}

class UserEntryWidget extends StatelessWidget {
  final String propertyName;
  final String? propertyValue;

  const UserEntryWidget({super.key, required this.propertyName, required this.propertyValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
