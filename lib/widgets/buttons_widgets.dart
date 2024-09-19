import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class RoundedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? colorText;

  const RoundedElevatedButton({
    Key? key,
    this.color,
    this.colorText,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color == null ? LColors.primary : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: LText.button(
                      color: color == null
                          ? LColors.white
                          : colorText == null
                              ? LColors.primary
                              : colorText)),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedElevatedButtonSmall extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? colorText;

  const RoundedElevatedButtonSmall({
    Key? key,
    this.color,
    this.colorText,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color == null ? LColors.primary : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: LText.button(
                      color: color == null
                          ? LColors.white
                          : colorText == null
                              ? LColors.primary
                              : colorText)),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonSmall extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? colorText;

  const ButtonSmall({
    Key? key,
    this.color,
    this.colorText,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  State<ButtonSmall> createState() => _ButtonSmallState();
}

class _ButtonSmallState extends State<ButtonSmall> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        foregroundColor: widget.colorText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
        child: Text(widget.text,
            textAlign: TextAlign.center,
            style: LText.button(color: widget.colorText)),
      ),
    );
  }
}

class RoundedElevatedButtonWhite extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const RoundedElevatedButtonWhite({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: LColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
        child: Text(text, style: LText.button(color: LColors.primary)),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? icon;
  final Color? color;

  const IconButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color == '' || color == null
            ? LColors.primary
            : color, // adjust color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/$icon',
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.0),
            Text(text, style: LText.button(color: LColors.white)),
          ],
        ),
      ),
    );
  }
}

class IconButtonSmallWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? icon;
  final Color? color;
  const IconButtonSmallWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            color == null ? Colors.blue : color, // adjust color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/$icon',
              fit: BoxFit.contain,
            ),
            text == '' || text == null ? SizedBox() : SizedBox(width: 8.0),
            text == '' || text == null ? SizedBox() : Text(text),
          ],
        ),
      ),
    );
  }
}

class IconButtonLineWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? icon;

  const IconButtonLineWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: LColors.white, // adjust color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        side: BorderSide(
            color: LColors.primary, width: 2), // Warna garis pinggiran
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/$icon',
              fit: BoxFit.contain,
              color: LColors.primary,
            ),
            SizedBox(width: 8.0),
            Text(text, style: LText.button(color: LColors.primary)),
          ],
        ),
      ),
    );
  }
}
