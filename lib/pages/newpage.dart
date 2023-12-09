import 'package:flutter/material.dart';

class NewPageWidget extends StatelessWidget {
  const NewPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "New page",
            style: Theme.of(context).textTheme.titleLarge!,
          )
        ],
      ),
    );
  }
}
