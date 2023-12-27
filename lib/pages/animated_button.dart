// ignore_for_file: public_member_api_docs

import 'package:flex_market/pages/button_material.dart';
import 'package:flutter/material.dart';

class AnimatedButtonPage extends StatefulWidget {
  const AnimatedButtonPage({ super.key});

  @override
  State<AnimatedButtonPage> createState() => _AnimatedButtonPageState();
}

class _AnimatedButtonPageState extends State<AnimatedButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedButton(
          onTap: () {
            print("animated button pressed");
          },
          animationDuration: const Duration(milliseconds: 2000),
          initialText: "Confirm",
          finalText: "Submitted",
          iconData: Icons.check,
          iconSize: 32,
          buttonStyle: CustomButtonStyle(
            primaryColor: Colors.green.shade600,
            secondaryColor: Colors.white,
            elevation: 20,
            initialTextStyle: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
            finalTextStyle: TextStyle(
              fontSize: 22,
              color: Colors.green.shade600,
            ),
            borderRadius: 10,
          ),
        ),
      ),
    );
  }
}