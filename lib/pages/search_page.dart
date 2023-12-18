import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
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

  /// Search query gender parameter
  SearchPageGender? selectedGender = SearchPageGender.all;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final List<String> categories = <String>[
      'Tops',
      'Bottoms',
      'Dresses',
      'Outer Wear',
      'Under Wear',
      'Foot Wear',
      'Accessories',
      'Sleep Wear',
      'Athletic',
      'Swimm Wear',
    ];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.10,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3D3D3B),
                ),
              ),
            ),
            child: Center(
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
                      child: Image.asset(
                        'assets/search.png',
                        width: 22,
                        height: 22,
                      ),
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
          ...categories.map((String category) {
            return Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: const Border(bottom: BorderSide(color: Color(0xFF3D3D3B))),
              ),
              child: InkWell(
                onTap: () {
                  // Handle category selection
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 29,
                    top: 13,
                  ),
                  child: Text(category),
                ),
              ),
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: margin),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF3D3D3B),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: ElevatedButton(
                onPressed: () {
                  // Handle search action
                },
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
          ),
        ],
      ),
    );
  }
}
