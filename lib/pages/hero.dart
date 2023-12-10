import 'package:flex_market/utils/constants.dart';
import 'package:flex_market/utils/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// A custom linear gradient shader used for text styling.
final Shader linearGradient = const LinearGradient(
  colors: <Color>[
    Color.fromRGBO(255, 79, 64, 100),
    Color.fromRGBO(255, 68, 221, 100),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
).createShader(const Rect.fromLTWH(0, 0, 500, 70));

/// The Hero widget for the FlexMarket application.
///
/// This widget is displayed when the user is not logged in,
/// featuring the application logo and a login button.
class HeroWidget extends StatelessWidget {
  /// Constructs a [HeroWidget] to display the authentication page.
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataProvider authProvider = Provider.of<DataProvider>(context);

    return Column(
      children: <Widget>[
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
              children: <Widget>[
                Text(
                  'Flex Market',
                  style: GoogleFonts.spaceGrotesk(
                    foreground: Paint()..shader = linearGradient,
                    fontSize: 80,
                    height: 0.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
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
                      Container(
                        margin: const EdgeInsets.only(top: margin),
                        child: ElevatedButton(
                          onPressed: authProvider.register,
                          child: Text(
                            'Register',
                            style: GoogleFonts.spaceGrotesk(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              height: 0.8,
                              fontWeight: FontWeight.w500,
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
        ),
      ],
    );
  }
}
