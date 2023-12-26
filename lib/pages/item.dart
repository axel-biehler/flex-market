import 'package:flex_market/components/image_viewer.dart';
import 'package:flex_market/models/item.dart';
import 'package:flex_market/providers/cart_provider.dart';
import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/enums.dart';
import 'package:flex_market/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that displays the details of an item.
class ItemWidget extends StatefulWidget {
  /// Creates an [ItemWidget].
  const ItemWidget({required this.item, super.key});

  /// Item to be displayed
  final Item item;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late ItemSize selectedSize;

  @override
  void initState() {
    super.initState();
    if (getAvailableSize(widget.item.stock) != null) {
      selectedSize = getAvailableSize(widget.item.stock)!;
    } else {
      selectedSize = ItemSize.xs;
    }
  }

  bool _isSizeInStock() {
    return widget.item.stock[selectedSize.name.toUpperCase()] != null && widget.item.stock[selectedSize.name.toUpperCase()]! > 0;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (widget.item.imagesUrl.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width - margin * 2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ...widget.item.imagesUrl.map((String url) {
                      return Padding(
                        padding: const EdgeInsets.only(right: margin),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ImageViewerWidget(
                              url: url,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${widget.item.price}',
                    style: const TextStyle(
                      color: Color(0xFFFF8E26),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.item.description,
                    style: const TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sizes',
                    style: TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ItemSize.values.map((ItemSize size) {
                      final bool outOfStock = widget.item.stock[size.name.toUpperCase()] == 0 || widget.item.stock[size.name.toUpperCase()] == null;
                      return ChoiceChip(
                        label: Text(
                          size.name.toUpperCase(),
                          style: TextStyle(
                            color: selectedSize == size ? Theme.of(context).primaryColor : Colors.white,
                            decoration: outOfStock ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        selected: selectedSize == size,
                        onSelected: (bool selected) {
                          if (!outOfStock) {
                            setState(() {
                              selectedSize = size;
                            });
                          }
                        },
                        selectedColor: const Color(
                          0xFFC2C2C2,
                        ),
                        backgroundColor: const Color(
                          0xFF121212,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        checkmarkColor: Colors.transparent,
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: Text(
                      'In stock: ${widget.item.stock[selectedSize.name.toUpperCase()]}',
                      style: const TextStyle(
                        color: Color(0xFFC2C2C2),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: margin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Specifications',
                          style: TextStyle(
                            color: Color(0xFFC2C2C2),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8), // Add some spacing between the title and rows
                        // Create a row for each spec in widget.item.specs
                        ...widget.item.specs.entries.map((MapEntry<String, dynamic> entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: margin / 2),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: Color(0xFFC2C2C2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: margin * 0.75),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFFC2C2C2),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: margin),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_isSizeInStock()) {
                          return;
                        }
                        final int quantity = context.read<CartProvider>().getItemQuantity(widget.item.id!);
                        await context.read<CartProvider>().addToCart(widget.item, selectedSize, quantity + 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSizeInStock() ? const Color(0xFF247100) : Theme.of(context).colorScheme.errorContainer,
                        fixedSize: const Size(120, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
