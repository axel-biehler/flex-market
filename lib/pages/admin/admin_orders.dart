import 'dart:math';
import 'package:flex_market/components/admin_orders_list.dart';
import 'package:flex_market/providers/order_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// A widget that displays the orders for admin.
///
/// It presents a scrollable list of orders that allows the admin to manage them.
class AdminOrdersWidget extends StatelessWidget {
  /// Creates a [AdminOrdersWidget].
  const AdminOrdersWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = kIsWeb ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight * 0.1,
            width: screenWidth,
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
                              child: SvgPicture.asset(
                                'assets/arrow.svg',
                                height: 20,
                              ),
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
                                'ORDERS',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontStyle: FontStyle.italic),
                              ),
                              Text(
                                '${context.watch<OrderProvider>().orders.length} orders',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AdminOrdersListWidget(
            navigatorKey: navigatorKey,
          ),
        ],
      ),
    );
  }
}
