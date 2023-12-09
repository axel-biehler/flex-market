import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/src/foundation/constants.dart';

class DataProvider extends ChangeNotifier {
  UserProfile? _user;
  Credentials? _credentials;

  final Auth0 auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
  final Auth0Web auth0Web = Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  UserProfile? get user => _user;
  Credentials? get credentials => _credentials;

  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }

  void setCredentials(Credentials? credentials) {
    _credentials = credentials;
    notifyListeners();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://x2rkz2iy7h.execute-api.eu-west-3.amazonaws.com/hello');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${_credentials!.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000', audience: dotenv.env['AUTH0_AUDIENCE']);
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(audience: dotenv.env['AUTH0_AUDIENCE'], scopes: {'openid', 'profile', 'email', 'offline_access', 'read:products'});
      _user = credentials.user;
      _credentials = credentials;
      await fetchData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:3000');
      } else {
        await auth0.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).logout();
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
