import 'package:flex_market/models/search_query.dart';
import 'package:flex_market/pages/search/search_results.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flex_market/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Search page with query options
class SearchPageWidget extends StatefulWidget {
  /// Creates a new [SearchPageWidget].
  const SearchPageWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  SearchPageWidgetState createState() => SearchPageWidgetState();
}

/// Search page state
class SearchPageWidgetState extends State<SearchPageWidget> {
  /// Controller for the query text input
  final TextEditingController _searchController = TextEditingController();

  /// Search query gender parameter
  SearchPageGender selectedGender = SearchPageGender.all;

  /// Search query categories parameter
  List<ItemCategory> selectedCategories = <ItemCategory>[];

  void _toggleCategory(ItemCategory category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  /// Trigger search action
  Future<void> search() async {
    final SearchQuery searchQuery = SearchQuery(
      query: _searchController.text,
      gender: selectedGender,
      categories: selectedCategories,
    );
    await widget.navigatorKey.currentState?.push(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => SearchResultsWidget(
          navigatorKey: widget.navigatorKey,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width;
    final double textFieldPadding = kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 0;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.10,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3B),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: textFieldPadding),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                      fontWeight: FontWeight.w300,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF3D3D3B),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/search.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _searchController.text = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: 50,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF3D3D3B))),
            ),
            child: ToggleButtons(
              constraints: BoxConstraints.expand(width: screenWidth / 3),
              isSelected: SearchPageGender.values.map((SearchPageGender g) => g == selectedGender).toList(),
              onPressed: (int index) {
                setState(() {
                  selectedGender = SearchPageGender.values[index];
                });
              },
              borderColor: Colors.grey,
              selectedBorderColor: Colors.black,
              fillColor: Colors.transparent,
              selectedColor: Theme.of(context).colorScheme.secondary,
              color: Theme.of(context).colorScheme.secondary,
              borderWidth: 1,
              borderRadius: BorderRadius.circular(0),
              renderBorder: false,
              children: SearchPageGender.values.map((SearchPageGender gender) {
                final bool isSelected = selectedGender == gender;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: SearchPageGender.values.indexOf(gender) != 2
                          ? Border(
                              right: BorderSide(color: Theme.of(context).colorScheme.secondary),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 29,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3D3D3B) : Colors.transparent,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Center(child: Text(gender.name.toString().toUpperCase())),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ItemCategory.values.length,
              itemBuilder: (BuildContext context, int index) {
                final ItemCategory category = ItemCategory.values[index];
                return Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selectedCategories.contains(category) ? const Color(0xFF3D3D3B) : Theme.of(context).primaryColor,
                    border: const Border(bottom: BorderSide(color: Color(0xFF3D3D3B))),
                  ),
                  child: InkWell(
                    onTap: () => _toggleCategory(category),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 29,
                        top: 13,
                      ),
                      child: Text(
                        capitalize(category.name),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: margin,
            ),
            child: ElevatedButton(
              onPressed: search,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D3D3B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Search',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
