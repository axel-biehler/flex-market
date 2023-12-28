import 'dart:async';
import 'dart:math';
import 'package:flex_market/components/admin_items_list.dart';
import 'package:flex_market/pages/admin/admin_item_form.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the user items if he is admin.
///
/// It presents a scrollable list of items that the user sells and allows him to
/// add more of them.
class AdminItemsWidget extends StatelessWidget {
  /// Creates a [AdminItemsWidget].
  const AdminItemsWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: margin),
                    child: Row(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF3D3D3B),
                          ),
                          child: IconButton(
                            icon: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset('assets/arrow.svg', height: 20),
                            ),
                            onPressed: () => navigatorKey.currentState?.pop(),
                            highlightColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: margin),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ITEMS',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontStyle: FontStyle.italic),
                              ),
                              Text(
                                '${context.watch<ItemProvider>().items.length} items',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: margin),
                  child: ElevatedButton(
                    onPressed: () {
                      unawaited(
                        navigatorKey.currentState?.push(
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => AdminItemFormWidget(navigatorKey: navigatorKey, isEdit: false),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF247100),
                      fixedSize: const Size(80, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AdminItemsListWidget(navigatorKey: navigatorKey),
        ],
      ),
    );
  }
}
