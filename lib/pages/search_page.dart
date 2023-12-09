import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';

/// Search page with query options
class SearchPageWidget extends StatefulWidget {
  /// Creates a new [SearchPageWidget].
  const SearchPageWidget({super.key});

  @override
  SearchPageWidgetState createState() => SearchPageWidgetState();
}

/// Search page state
class SearchPageWidgetState extends State<SearchPageWidget> {
  /// Search query text input value
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.12,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3B),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: padding),
              child: TextField(
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
                      child: Image.asset('assets/search.png'),
                    ),
                  ),
                  suffixIcon: searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              searchText = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
                onChanged: (String text) {
                  setState(() {
                    searchText = text;
                  });
                },
              ),
            ),
          ),
          // Add other widgets here that might depend on the searchText
        ],
      ),
    );
  }
}
