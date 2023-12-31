import 'dart:math';

import 'package:flex_market/components/picture_preview.dart';
import 'package:flex_market/models/user_profile.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Edit profile page.
class EditProfilePage extends StatefulWidget {
  /// Creates a [EditProfilePage].
  const EditProfilePage({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final User? user =
        Provider.of<AuthProvider>(context, listen: false).userCustom;
    _firstNameController = TextEditingController(text: user?.name ?? '');
    _lastNameController = TextEditingController(text: user?.nickname ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: <Widget>[
          _buildHeader(context, screenHeight, screenWidth),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildForm(context, screenWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, double screenHeight, double screenWidth) {
    return SizedBox(
      height: screenHeight * 0.1,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: margin),
              child: Row(
                children: <Widget>[
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFF3D3D3B),
                    ),
                    child: IconButton(
                      icon: Transform.rotate(
                        angle: pi,
                        child: SvgPicture.asset('assets/arrow.svg', height: 20),
                      ),
                      onPressed: () => widget.navigatorKey.currentState?.pop(),
                      highlightColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: margin),
                    child: Text(
                      'MY ACCOUNT',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontStyle: FontStyle.italic),
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

  Form _buildForm(BuildContext context, double screenWidth) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: margin),
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    context
                        .watch<AuthProvider>()
                        .userCustom!
                        .picture
                        .toString(),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.white,
                onPressed: () async {
                  await widget.navigatorKey.currentState?.push(
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => PicturePreviewPage(
                        navigatorKey: widget.navigatorKey,
                        maxPictures: 1,
                        callback: (List<XFile> pics) async {
                          final ImageManagementProvider
                              imageManagementProvider =
                              context.read<ImageManagementProvider>();
                          final AuthProvider authProvider =
                              context.read<AuthProvider>();
                          final String? path = await authProvider
                              .editProfilePicture(pics.first.name);
                          await imageManagementProvider.uploadXFileToS3(
                            pics.first,
                            path!,
                          );
                          imageManagementProvider.clearImageUrls();
                          await authProvider.fetchUserInfo();
                          await authProvider.notify();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            TextFormField(
              controller: _firstNameController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Name'),
              validator: (String? value) =>
                  value!.isEmpty ? 'Please enter your first name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Nickname'),
              validator: (String? value) =>
                  value!.isEmpty ? 'Please enter your last name' : null,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                // ignore: always_specify_types
                onPressed: () async => <Future>{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                          'Are you sure you want to delete your account?',
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  // ignore: always_specify_types
                                  .popUntil((Route route) => route.isFirst);
                              context.read<AuthProvider>().deleteAccount();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  ),
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete Account'),
              ),
            ),
            _buildSaveCancelButtons(context),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  Widget _buildSaveCancelButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            fixedSize: const Size(120, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'CANCEL',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _saveProfile();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF247100),
            fixedSize: const Size(120, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'SAVE',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> updatedUserData = <String, dynamic>{
        'name': _firstNameController.text,
        'nickname': _lastNameController.text,
      };

      // Call the AuthProvider to update the user data
      final bool success =
          await context.read<AuthProvider>().editUser(updatedUserData);

      if (success) {
        await _showSuccessDialog();
      } else {
        // If the update failed, show an error message
        await _showErrorDialog('Failed to update profile. Please try again.');
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Profile Saved',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          content: Text(
            'Your profile has been updated successfully!',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
