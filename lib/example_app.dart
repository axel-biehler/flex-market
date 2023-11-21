import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants.dart';
import 'hero.dart';
import 'user.dart';

class ExampleApp extends StatefulWidget {
  final Auth0? auth0;
  const ExampleApp({this.auth0, super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  UserProfile? _user;
  Credentials? _credentials;

  late Auth0 auth0;
  late Auth0Web auth0Web;

  @override
  void initState() {
    super.initState();
    auth0 = widget.auth0 ??
        Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    auth0Web =
        Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) => setState(() {
            _user = credentials?.user;
          }));
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://x2rkz2iy7h.execute-api.eu-west-3.amazonaws.com/hello');

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
        return auth0Web.loginWithRedirect(
            redirectUrl: 'http://localhost:3000',
            audience: dotenv.env['AUTH0_AUDIENCE']);
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(audience: dotenv.env['AUTH0_AUDIENCE'], scopes: {
        'openid',
        'profile',
        'email',
        'offline_access',
        'read:products'
      });

      setState(() {
        _user = credentials.user;
        _credentials = credentials;
      });
      await fetchData();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:3000');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
        setState(() {
          _user = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(
          top: padding,
          bottom: padding,
          left: padding / 2,
          right: padding / 2,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: Row(children: [
            _user != null
                ? Expanded(child: UserWidget(user: _user))
                : const Expanded(child: HeroWidget())
          ])),
          _user != null
              ? ElevatedButton(
                  onPressed: logout,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('Logout'),
                )
              : ElevatedButton(
                  onPressed: login,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('Login'),
                ),
          if (_user != null)
            ElevatedButton(
              onPressed: () => fetchData(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('try request'),
            )
        ]),
      )),
    );
  }
}
