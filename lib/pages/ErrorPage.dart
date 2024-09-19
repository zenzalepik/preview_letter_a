import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width:double.infinity,
        color: LColors.primary,
        child: Center(
          child: Text("We Are Sorry, There is Something error",
              textAlign: TextAlign.center,
              style: LText.button(color: LColors.white)),
        ));
  }
}
