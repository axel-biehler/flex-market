import 'package:flutter/material.dart';

/// A components that dynamically render a button with an animation uppon click
class AnimatedButton extends StatefulWidget {
  /// Creates an [AnimatedButton].
  const AnimatedButton({
    required this.initialText,
    required this.finalText,
    required this.iconData,
    required this.iconSize,
    required this.animationDuration,
    required this.buttonStyle,
    required this.onTap,
    super.key,
  });

  ///Text to be displayed before clicking
  final String initialText;

  ///Text to be displayed after clicking
  final String finalText;

  ///Custom style for the button
  final CustomButtonStyle buttonStyle;

  ///Icon displayed on the button
  final IconData iconData;

  ///Size of this icon
  final double iconSize;

  ///Durantion of the animation
  final Duration animationDuration;

  ///Button logic
  final Function onTap;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late ButtonState _currentState;
  late Duration _smallDuration;
  late Animation<double> _scaleFinalTextAnimation;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.showOnlyText;
    _smallDuration = Duration(
      milliseconds: (widget.animationDuration.inMilliseconds * 0.2).round(),
    );
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _controller
      ..addListener(() {
        final double controllerValue = _controller.value;
        if (controllerValue < 0.2) {
          setState(() {
            _currentState = ButtonState.showOnlyIcon;
          });
        } else if (controllerValue > 0.8) {
          setState(() {
            _currentState = ButtonState.showTextIcon;
          });
        }
      })
      ..addStatusListener((AnimationStatus currentStatus) {
        if (currentStatus == AnimationStatus.completed) {
          widget.onTap();
        }
      });

    _scaleFinalTextAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.buttonStyle.elevation,
      borderRadius: BorderRadius.all(Radius.circular(widget.buttonStyle.borderRadius)),
      child: InkWell(
        onTap: () {
          _controller.forward();
        },
        child: AnimatedContainer(
          duration: _smallDuration,
          height: widget.iconSize + 16,
          decoration: BoxDecoration(
            color: (_currentState == ButtonState.showOnlyIcon || _currentState == ButtonState.showTextIcon)
                ? widget.buttonStyle.secondaryColor
                : widget.buttonStyle.primaryColor,
            border: Border.all(
              color: (_currentState == ButtonState.showOnlyIcon || _currentState == ButtonState.showTextIcon)
                  ? widget.buttonStyle.primaryColor
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.buttonStyle.borderRadius),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: _smallDuration,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_currentState == ButtonState.showOnlyIcon || _currentState == ButtonState.showTextIcon)
                  Icon(
                    widget.iconData,
                    size: widget.iconSize,
                    color: widget.buttonStyle.primaryColor,
                  )
                else
                  Container(),
                if (_currentState == ButtonState.showTextIcon)
                  const SizedBox(
                    width: 16,
                  ),
                getTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTextWidget() {
    if (_currentState == ButtonState.showOnlyText) {
      return Text(
        widget.initialText,
        style: widget.buttonStyle.initialTextStyle,
      );
    } else if (_currentState == ButtonState.showOnlyIcon) {
      return Container();
    } else {
      return ScaleTransition(
        scale: _scaleFinalTextAnimation,
        child: Text(
          widget.finalText,
          style: widget.buttonStyle.finalTextStyle,
        ),
      );
    }
  }
}

///Class that define the style of a button
class CustomButtonStyle {
  ///Creates a [CustomButtonStyle]
  CustomButtonStyle({
    required this.primaryColor,
    required this.secondaryColor,
    required this.initialTextStyle,
    required this.finalTextStyle,
    required this.elevation,
    required this.borderRadius,
  });

  ///Style for the texted displayed before clicking
  final TextStyle initialTextStyle;

  ///Style for the texted displayed after clicking
  final TextStyle finalTextStyle;

  ///Color of the button before clicking
  final Color primaryColor;

  ///Color of the button before clicking
  final Color secondaryColor;

  ///Button elevation
  final double elevation;

  ///Button border radius
  final double borderRadius;
}

///Enum for button actual state
enum ButtonState {
  ///First state where only "Adding to cart" is shown
  showOnlyText,

  ///Second state where only the validate icon is shown
  showOnlyIcon,

  ///Last state where the validate icon and "Added" is chown
  showTextIcon
}
