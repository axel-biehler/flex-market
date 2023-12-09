import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Cart",
            style: Theme.of(context).textTheme.titleLarge!,
          )
        ],
      ),
    );
  }
}
