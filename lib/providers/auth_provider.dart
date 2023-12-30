import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flex_market/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Manages the application state including user authentication,
/// product data, and shopping cart functionality.
///
/// This class acts as a central hub for the state management within
/// the application, leveraging Flutter's Provider package for state
/// notification and updates.
class AuthProvider extends ChangeNotifier {
  /// The current user profile, null if not authenticated.
  UserProfile? _user;
  User? _userCustom;

  /// The current user's credentials, null if not authenticated.
  Credentials? _credentials;

  /// The current user's authentication status.
  bool? _isAuthenticated;

  /// Instance of Auth0 for user authentication.
  final Auth0 auth0 =
      Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  /// Instance of Auth0Web for web-based authentication.
  final Auth0Web auth0Web =
      Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_WEB_CLIENT_ID']!);

  /// Getter for the current user.
  UserProfile? get user => _user;

  /// Getter for the current user's authentication status.
  bool? get isAuthenticated => _isAuthenticated;

  /// Getter for the current user custom.
  User? get userCustom => _userCustom;

  /// Getter for the current user's credentials.
  Credentials? get credentials => _credentials;

  /// Init Auth0Web for web-based authentication.
  Future<Credentials?> initWebAuth() async {
    if (kIsWeb) {
      final Credentials? credentials = await auth0Web.onLoad();
      _credentials = credentials;
      _user = credentials?.user;
      return credentials;
    }
    return null;
  }

  /// Sets the current user and notifies listeners about the change.
  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }

  /// Sets the current user custom and notifies listeners about the change.
  void setCustomUser(User? user, {bool isAdmin = false}) {
    _userCustom = user;
    _userCustom!.isAdmin = isAdmin;
    notifyListeners();
  }

  /// Sets the current user's credentials and notifies listeners about the change.
  void setCredentials(Credentials? credentials) {
    _credentials = credentials;
    notifyListeners();
  }

  /// Handles user login using Auth0 authentication.
  Future<void> login() async {
    try {
      _isAuthenticated = false;
      notifyListeners();
      if (kIsWeb) {
        final Credentials credentials = await auth0Web.loginWithPopup(
          audience: dotenv.env['AUTH0_AUDIENCE'],
        );
        _user = credentials.user;
        _credentials = credentials;
        notifyListeners();
        return;
      }
      final Credentials credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(
        audience: dotenv.env['AUTH0_AUDIENCE'],
        scopes: <String>{
          'openid',
          'profile',
          'email',
          'offline_access',
          'admin',
        },
        parameters: <String, String>{
          'initial_screen': 'login',
        },
      );
      _user = credentials.user;
      _credentials = credentials;
      await fetchUserInfo();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Handles user register using Auth0 authentication.
  Future<void> register() async {
    _isAuthenticated = false;
    notifyListeners();
    try {
      if (kIsWeb) {
        final Credentials credentials = await auth0Web.loginWithPopup(
          audience: dotenv.env['AUTH0_AUDIENCE'],
        );
        _user = credentials.user;
        _credentials = credentials;
        await fetchUserInfo();
        notifyListeners();
        return;
      }
      final Credentials credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(
        audience: dotenv.env['AUTH0_AUDIENCE'],
        scopes: <String>{
          'openid',
          'profile',
          'email',
          'offline_access',
          'read:products',
        },
        parameters: <String, String>{
          'initial_screen': 'signup',
        },
      );
      _user = credentials.user;
      _credentials = credentials;
      notifyListeners();
      await fetchUserInfo();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Handles user logout and state cleanup.
  Future<void> logout() async {
    try {
      _isAuthenticated = null;
      notifyListeners();
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: dotenv.env['AUTH0_REDIRECT_URI']);
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Fetches user information from a specified API endpoint and handles the response.
  Future<void> fetchUserInfo() async {
    final Uri url = Uri.parse(
      '${dotenv.env['API_URL']}/me',
    );

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${_credentials?.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response data: ${response.body}');
        }
        final String role = await fetchUserRoles(_credentials!);
        setCustomUser(
          User.fromJson(jsonDecode(response.body)['profile']),
          isAdmin: role == 'admin',
        );
        _isAuthenticated = true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  /// Fetches user roles from a specified API endpoint and handles the response.
  Future<String> fetchUserRoles(Credentials credentials) async {
    final Uri url = Uri.parse(
      '${dotenv.env['API_URL']}/me/roles',
    );

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response data: ${response.body}');
        }

        final String role = (jsonDecode(response.body)['profile'] != null &&
                jsonDecode(response.body)['profile'].isNotEmpty)
            ? 'admin'
            : 'user';

        return role;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return 'user';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    return 'user';
  }

  /// Edits the current user's profile.
  Future<bool> editUser(Map<String, dynamic> updates) async {
    if (_user == null || _credentials == null) {
      return false;
    }

    final Uri url = Uri.parse('${dotenv.env['API_URL']}/me');
    try {
      final http.Response response = await http.patch(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials!.accessToken}',
        },
        body: jsonEncode(<String, dynamic>{
          'name': updates['name'],
          'nickname': updates['nickname'],
        }),
      );

      if (response.statusCode == 200) {
        // Update local user profile with new details
        final String role = await fetchUserRoles(credentials!);
        setCustomUser(
          User.fromJson(jsonDecode(response.body)['profile']),
          isAdmin: role == 'admin',
        );
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }

  /// Edits profile picture of the current user.
  Future<String?> editProfilePicture(String imageUrl) async {
    if (_user == null || _credentials == null) {
      return null;
    }

    final Uri url = Uri.parse('${dotenv.env['API_URL']}/me');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${credentials!.accessToken}',
        },
        body: jsonEncode(<String, dynamic>{
          'key': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['url'];
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    return null;
  }

  /// Notifies listeners about a change in the state.
  Future<void> notify() async {
    notifyListeners();
  }
}
