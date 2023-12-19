import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the details of a product.
class ItemPage extends StatefulWidget {
  /// Creates an [ItemPage].
  const ItemPage({required this.productId, super.key});

  /// The ID of the product to display.
  final String productId;

  @override
  ItemPageState createState() => ItemPageState();
}

/// The state of the [ItemPage].
class ItemPageState extends State<ItemPage> {
  /// The size of the product to display.
  String? selectedSize;

  late Future<Item> _itemFuture;

  @override
  Future<void> initState() async {
    super.initState();
    // Initialize the future here
    final ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    _itemFuture = itemProvider.fetchProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2C2C2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Item>(
        future: _itemFuture,
        builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Color(0xFFC2C2C2)),
              ),
            );
          } else if (snapshot.hasData) {
            final Item item = snapshot.data!;
            // Example sizes, replace with actual sizes from item if available
            final List<String> itemSizes = <String>[
              'XS',
              'S',
              'M',
              'L',
              'XL',
              'XXL',
            ];

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: const Placeholder(
                      color: Color(
                        0xFFC2C2C2,
                      ),
                    ), // Replace with item image carousel
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Color(0xFFC2C2C2),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${item.price}',
                          style: const TextStyle(
                            color: Color(0xFFFF8E26),
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: Color(0xFFC2C2C2),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Size',
                          style: TextStyle(
                            color: Color(0xFFC2C2C2),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: itemSizes.map((String size) {
                            final bool outOfStock = item.stock[size] == 0 ||
                                item.stock[size] == null;
                            return ChoiceChip(
                              label: Text(
                                size,
                                style: TextStyle(
                                  color: selectedSize == size
                                      ? Colors.white
                                      : const Color(0xFFC2C2C2),
                                  decoration: outOfStock
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              selected: selectedSize == size,
                              onSelected: outOfStock
                                  ? null
                                  : (bool selected) {
                                      setState(() {
                                        selectedSize = size;
                                      });
                                    },
                              selectedColor: const Color(
                                0xFFC2C2C2,
                              ), // Color when selected
                              backgroundColor: const Color(
                                0xFF121212,
                              ), // Consistent background color
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              // Remove checkmark by using an empty Widget
                              checkmarkColor: Colors.transparent,
                            );
                          }).toList(),
                        ),
                        if (selectedSize != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            'In stock: ${item.stock[selectedSize]}',
                            style: const TextStyle(
                              color: Color(0xFFC2C2C2),
                              fontSize: 16,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: selectedSize != null ? null : null,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green, // Text color
                              minimumSize: const Size(120, 50),
                            ),
                            child: const Text('ADD TO CART'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(color: Color(0xFFC2C2C2)),
              ),
            );
          }
        },
      ),
    );
  }
}
