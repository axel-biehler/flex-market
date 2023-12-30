import 'dart:math';

import 'package:flex_market/models/item.dart';
import 'package:flex_market/models/order.dart';
import 'package:flex_market/pages/item.dart';
import 'package:flex_market/providers/auth_provider.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flex_market/providers/order_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Order detail page.
class OrderDetailPage extends StatefulWidget {
  /// Constructor.
  const OrderDetailPage({
    required this.order,
    required this.navigatorKey,
    super.key,
  });

  /// Order object.
  final Order order;

  /// Navigator key.
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        Provider.of<AuthProvider>(context, listen: false).userCustom!.isAdmin ??
            false;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: <Widget>[
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _orderDetailText(
                    'Total Amount: \$${widget.order.totalAmount.toString()}',
                  ),
                  _orderDetailText(
                    'Order Date: ${widget.order.orderDate.toLocal()}',
                  ),
                  _orderDetailText('Status: $_currentStatus'),
                  _orderDetailText(
                    'Shipping Address: ${widget.order.shippingAddress}',
                  ),
                  _buildOrderItemsList(context),
                  if (isAdmin) ...<Widget>[
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: _currentStatus,
                      items: <String>[
                        'PENDING',
                        'COMPLETED',
                        'CANCELLED',
                        'SENT',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentStatus = newValue!;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: margin * 2),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _updateOrderStatus();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF247100),
                          fixedSize: const Size(100, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 80, // Adjust the height to avoid overflow
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
                      onPressed: () => widget.navigatorKey.currentState?.pop(),
                      highlightColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: margin),
                      child: Text(
                        'Order ID: ${widget.order.orderId}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: margin),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _buildOrderItemsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.order.items.map((OrderItem orderItem) {
        final Item? item =
            context.read<ItemProvider>().getById(orderItem.itemId);
        return ListTile(
          title: Text(
            item?.name ?? '',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontStyle: FontStyle.italic),
          ),
          subtitle: Text(
            'Quantity: ${orderItem.quantity}, Size: ${sizeToString(orderItem.size)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (item != null) {
                await widget.navigatorKey.currentState?.push(
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => ItemWidget(item: item),
                  ),
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Future<void> _updateOrderStatus() async {
    if (_currentStatus != widget.order.status) {
      final bool success =
          await Provider.of<OrderProvider>(context, listen: false)
              .updateOrderStatus(widget.order.orderId, _currentStatus);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $_currentStatus'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update order status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
