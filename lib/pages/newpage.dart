import 'package:flutter/material.dart';

/// Page template to create a new page quickly
class NewPageWidget extends StatelessWidget {
  /// Creates a new [Page] widget
  const NewPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'New page',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
        ],
      ),
    );
  }
}
