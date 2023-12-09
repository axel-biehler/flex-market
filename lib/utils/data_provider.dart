import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flex_market/utils/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Manages the application state including user authentication,
/// product data, and shopping cart functionality.
///
/// This class acts as a central hub for the state management within
/// the application, leveraging Flutter's Provider package for state
/// notification and updates.
class DataProvider extends ChangeNotifier {
  /// The current user profile, null if not authenticated.
  UserProfile? _user;

  /// The current user's credentials, null if not authenticated.
  Credentials? _credentials;

  /// The shopping cart containing a list of products.
  final List<Product> _cart = <Product>[];

  /// Instance of Auth0 for user authentication.
  final Auth0 auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  /// Instance of Auth0Web for web-based authentication.
  final Auth0Web auth0Web = Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  /// Getter for the current user.
  UserProfile? get user => _user;

  /// Getter for the current user's credentials.
  Credentials? get credentials => _credentials;

  /// A list of mock products used for displaying in the UI.
  List<Product> mockProducts = <Product>[
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
    Product(title: 'Air force one', imageUrl: 'assets/shoes.png', price: 189.90),
  ];

  /// Sets the current user and notifies listeners about the change.
  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }

  /// Sets the current user's credentials and notifies listeners about the change.
  void setCredentials(Credentials? credentials) {
    _credentials = credentials;
    notifyListeners();
  }

  /// Adds a product to the shopping cart and notifies listeners.
  void addToCart(Product product) {
    if (kDebugMode) {
      print('add to card $product');
    }
    _cart.add(product);
    if (kDebugMode) {
      print('cart $_cart');
    }
    notifyListeners();
  }

  /// Fetches data from a specified API endpoint and handles the response.
  Future<void> fetchData() async {
    final Uri url = Uri.parse('https://x2rkz2iy7h.execute-api.eu-west-3.amazonaws.com/hello');

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${_credentials!.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response data: ${response.body}');
        }
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

  /// Handles user login using Auth0 authentication.
  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:39213', audience: dotenv.env['AUTH0_AUDIENCE']);
      }
      final Credentials credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login(audience: dotenv.env['AUTH0_AUDIENCE'], scopes: <String>{'openid', 'profile', 'email', 'offline_access', 'read:products'});
      _user = credentials.user;
      _credentials = credentials;
      await fetchData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Handles user logout and state cleanup.
  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:39213');
      } else {
        await auth0.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).logout();
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
