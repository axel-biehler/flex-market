import 'package:flex_market/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Shader linearGradient = const LinearGradient(
        colors: <Color>[Color.fromRGBO(255, 79, 64, 100), Color.fromRGBO(255, 68, 221, 100)], begin: Alignment.topLeft, end: Alignment.bottomRight)
    .createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 70.0));

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<DataProvider>(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: margin * 2),
          child: SvgPicture.asset('assets/logo.svg', width: 192),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(margin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flex market',
                  style: GoogleFonts.spaceGrotesk(
                    foreground: Paint()..shader = linearGradient,
                    fontSize: 80,
                    height: 0.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: margin * 16),
                    child: ElevatedButton(
                      onPressed: authProvider.login,
                      child: Text(
                        'Login',
                        style: GoogleFonts.spaceGrotesk(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          height: 0.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
