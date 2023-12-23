import 'dart:async';

import 'package:flex_market/pages/flex_market_app.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/providers/image_management_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

/// A widget that represents the root of the application.
///
/// This class sets up the overall theme of the app and defines the home screen.
class App extends StatelessWidget {
  /// Creates an instance of [App].
  App({super.key});

  /// The theme data used throughout the app.
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    unawaited(context.read<AuthProvider>().initWebAuth());
    return MaterialApp(
      theme: theme.copyWith(
        primaryColor: const Color(0xFF121212),
        colorScheme: theme.colorScheme.copyWith(
          secondary: const Color(0xFFC2C2C2),
          errorContainer: const Color(0xFF8E0000),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C2C2),
            fontFamily: 'Jost',
          ),
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC2C2C2),
            fontFamily: 'Jost',
          ),
          bodySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Color(0xFFC2C2C2),
            fontFamily: 'Jost',
            letterSpacing: 3,
          ),
          labelMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC2C2C2),
            fontFamily: 'Jost',
            letterSpacing: 3,
          ),
        ),
      ),
      home: const FlexMarketApp(),
    );
  }
}

/// The entry point of the application.
///
/// It initializes environment variables and sets up the provider for state management.
void main() async {
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ImageManagementProvider>(
          create: (_) => ImageManagementProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (BuildContext context) => CartProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (
            BuildContext context,
            AuthProvider authProvider,
            CartProvider? previousDataProvider,
          ) =>
              previousDataProvider!..updateWithAuthProvider(authProvider),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ItemProvider>(
          create: (BuildContext context) => ItemProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (
            BuildContext context,
            AuthProvider authProvider,
            ItemProvider? previousDataProvider,
          ) =>
              previousDataProvider!..updateWithAuthProvider(authProvider),
        ),
      ],
      child: App(),
    ),
  );
}
