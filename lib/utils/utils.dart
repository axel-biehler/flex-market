import 'package:flex_market/utils/enums.dart';

/// Get the first available size or return null
ItemSize? getAvailableSize(Map<String, int> stock) {
  if (stock.entries.any((MapEntry<String, int> entry) => entry.value > 0)) {
    return stringToSize(stock.entries.firstWhere((MapEntry<String, int> entry) => entry.value > 0).key);
  }
  return null;
}

/// Capitalize the first letter of a string
String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}
