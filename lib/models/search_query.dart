import 'package:flex_market/utils/enums.dart';

/// Represents a search query with a text, a gender and categories.
///
/// This class is used to store all the information related to a search query.
class SearchQuery {
  /// Creates a [SearchQuery] with the given [query], [gender] and [categories].
  SearchQuery({required this.query, required this.gender, required this.categories});

  /// A query string to search in the item's names
  final String query;

  /// A gender to filter on the available gender
  final SearchPageGender gender;

  /// The categories included in the search
  final List<ItemCategory> categories;
}
