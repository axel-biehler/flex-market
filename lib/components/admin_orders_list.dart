import 'dart:async';

import 'package:flex_market/models/order.dart';
import 'package:flex_market/pages/order_details.dart';
import 'package:flex_market/providers/order_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the orders published by an admin vertically.
///
/// This widget creates a vertical list of order cards, each card displaying
/// key information about the order. Each order card also includes a button
/// to go to the order detail or edit page.
class AdminOrdersListWidget extends StatelessWidget {
  /// Creates a [AdminOrdersListWidget].
  const AdminOrdersListWidget({required this.navigatorKey, super.key});

  /// Key used for custom navigation flow inside each app section
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    if (context.watch<OrderProvider>().orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.77,
          child: ListView.builder(
            itemCount: context.watch<OrderProvider>().orders.length,
            itemBuilder: (BuildContext context, int index) {
              final Order order = context.watch<OrderProvider>().orders[index];
              return InkWell(
                onTap: () {
                  unawaited(
                    navigatorKey.currentState?.push(
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => OrderDetailPage(
                          order: order,
                          navigatorKey: navigatorKey,
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(margin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Order ID: ${order.orderId}',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: margin),
                          child: Text(
                            'Total Amount: \$${order.totalAmount.toString()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: margin),
                          child: Text(
                            'Order Date: ${order.orderDate.toLocal()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: margin),
                          child: Text(
                            'Status: ${order.status}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
