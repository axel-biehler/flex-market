import 'package:flex_market/components/picture_preview.dart';
import 'package:flex_market/models/user_profile.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Edit profile page.
class EditProfilePage extends StatefulWidget {
  /// Creates an instance of [EditProfilePage].
  const EditProfilePage({required this.navigatorKey, super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Maxime Frechard', // Placeholder for user's full name
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _saveProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          title: const Text('Profile Saved'),
          content: const Text('Your profile has been updated successfully!'),
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
    _birthDateController.dispose();
    super.dispose();
  }
}
