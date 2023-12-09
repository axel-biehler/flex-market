import 'package:flex_market/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'flex_market_app.dart';

class App extends StatelessWidget {
  final ThemeData theme = ThemeData();

  App({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: theme.copyWith(
        primaryColor: const Color(0xFF121212),
        colorScheme: theme.colorScheme.copyWith(secondary: const Color(0xFFC2C2C2)),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C2C2),
            fontFamily: "Jost",
          ),
          titleLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC2C2C2),
            fontFamily: "Jost",
          ),
        ),
      ),
      home: const FlexMarketApp(),
    );
  }
}

void main() async {
  await dotenv.load();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: App(),
    ),
  );
}
