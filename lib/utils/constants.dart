import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Standard padding used in the app layout
const double padding = 40;

/// Standard margin used in the app layout
const double margin = 16;

/// The URL for the API endpoint.
final String apiUrl = dotenv.env['API_URL']!;
