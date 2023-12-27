// ignore_for_file: public_member_api_docs, library_private_types_in_public_api, void_checks, constant_identifier_names

import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({required this.initialText, required this.finalText, required this.iconData, required this.iconSize, required this.animationDuration, required this.buttonStyle, required this.onTap, super.key,
  });
  final String initialText;
  final String finalText;
  final CustomButtonStyle buttonStyle;
  final IconData iconData;
  final double iconSize;
  final Duration animationDuration;
  final Function onTap;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late ButtonState _currentState;
  late Duration _smallDuration;
  late Animation<double> _scaleFinalTextAnimation;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.SHOW_ONLY_TEXT;
    _smallDuration = Duration(
        milliseconds: (widget.animationDuration.inMilliseconds * 0.2).round(),);
    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _controller..addListener(() {
      final double controllerValue = _controller.value;
      if (controllerValue < 0.2) {
        setState(() {
          _currentState = ButtonState.SHOW_ONLY_ICON;
        });
      } else if (controllerValue > 0.8) {
        setState(() {
          _currentState = ButtonState.SHOW_TEXT_ICON;
        });
      }
    })

    ..addStatusListener((AnimationStatus currentStatus) {
      if (currentStatus == AnimationStatus.completed) {
        return widget.onTap();
      }
    });

    _scaleFinalTextAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller);
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
      borderRadius:
          BorderRadius.all(Radius.circular(widget.buttonStyle.borderRadius)),
      child: InkWell(
        onTap: () {
          _controller.forward();
        },
        child: AnimatedContainer(
          duration: _smallDuration,
          height: widget.iconSize + 16,
          decoration: BoxDecoration(
            color: (_currentState == ButtonState.SHOW_ONLY_ICON ||
                    _currentState == ButtonState.SHOW_TEXT_ICON)
                ? widget.buttonStyle.secondaryColor
                : widget.buttonStyle.primaryColor,
            border: Border.all(
              color: (_currentState == ButtonState.SHOW_ONLY_ICON ||
                      _currentState == ButtonState.SHOW_TEXT_ICON)
                  ? widget.buttonStyle.primaryColor
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.buttonStyle.borderRadius),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal:
                (_currentState == ButtonState.SHOW_ONLY_ICON) ? 16.0 : 48.0,
            vertical: 8,
          ),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: _smallDuration,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_currentState == ButtonState.SHOW_ONLY_ICON ||
                        _currentState == ButtonState.SHOW_TEXT_ICON) Icon(
                        widget.iconData,
                        size: widget.iconSize,
                        color: widget.buttonStyle.primaryColor,
                      ) else Container(),
                SizedBox(
                  width:
                      _currentState == ButtonState.SHOW_TEXT_ICON ? 30.0 : 0.0,
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
    if (_currentState == ButtonState.SHOW_ONLY_TEXT) {
      return Text(
        widget.initialText,
        style: widget.buttonStyle.initialTextStyle,
      );
    } else if (_currentState == ButtonState.SHOW_ONLY_ICON) {
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

class CustomButtonStyle {
  CustomButtonStyle({
    required this.primaryColor,
    required this.secondaryColor,
    required this.initialTextStyle,
    required this.finalTextStyle,
    required this.elevation,
    required this.borderRadius,
  });
  final TextStyle initialTextStyle;
  final TextStyle finalTextStyle;
  final Color primaryColor;
  final Color secondaryColor;
  final double elevation;
  final double borderRadius;
}

enum ButtonState { SHOW_ONLY_TEXT, SHOW_ONLY_ICON, SHOW_TEXT_ICON }
