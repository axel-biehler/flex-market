import 'dart:math';
import 'package:flex_market/components/image_viewer.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/models/search_query.dart';
import 'package:flex_market/pages/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Search page with query options
class SearchResultsWidget extends StatefulWidget {
  /// Creates a new [SearchResultsWidget].
  const SearchResultsWidget({
    required this.navigatorKey,
    required this.searchQuery,
    super.key,
  });

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  /// [SearchQuery] object containing the query parameters
  final SearchQuery searchQuery;

  @override
  SearchResultsWidgetState createState() => SearchResultsWidgetState();
}

/// Search page state
class SearchResultsWidgetState extends State<SearchResultsWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width;
    final List<Item> searchResults = context.read<ItemProvider>().getFilteredItems(widget.searchQuery);
    const int crossAxisCount = 2;
    const double crossAxisSpacing = 40;
    final double cardWidth = (screenWidth - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
    final double headerMargin = kIsWeb ? MediaQuery.of(context).size.width * 0.2 + margin : margin / 3;

    return Container(
      margin: const EdgeInsets.only(top: margin, left: margin / 2),
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: headerMargin),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: margin),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFF3D3D3B),
                    ),
                    child: IconButton(
                      icon: Transform.rotate(
                        angle: pi,
                        child: SvgPicture.asset(
                          'assets/arrow.svg',
                          height: 20,
                        ),
                      ),
                      onPressed: () => widget.navigatorKey.currentState?.pop(),
                      highlightColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Text>[
                    Text(
                      'Results',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      '${searchResults.length} items',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              height: screenHeight * 0.79,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: margin),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: 10,
                    childAspectRatio: cardWidth / (screenHeight * 0.7 / 2.5),
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Item item = searchResults[index];
                    return InkWell(
                      onTap: () async {
                        await widget.navigatorKey.currentState?.push(
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => ItemWidget(item: item),
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (item.imagesUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    child: ImageViewerWidget(
                                      url: item.imagesUrl.first,
                                    ),
                                  ),
                                Text(
                                  '\$${item.price.toString()}',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
