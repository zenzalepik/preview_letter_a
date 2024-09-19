import 'package:flutter/material.dart';

class LText {
  static TextStyle ratingNumber({Color? color}) {
    return TextStyle(
      fontSize: 80,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle H05({Color? color}) {
    return TextStyle(
      fontSize: 24,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle H1({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle H2({Color? color}) {
    return TextStyle(
      fontSize: 32,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
      letterSpacing: -1,
    );
  }

  static TextStyle H3({Color? color}) {
    return TextStyle(
      fontSize: 28,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
      height: 1.1,
    );
  }

  static TextStyle H5({Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: 20,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: weight == null ? FontWeight.w600 : weight,
    );
  }

  static TextStyle subtitle({Color? color}) {
    return TextStyle(
      fontSize: 18,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle button({Color? color}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.white,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelData({Color? color}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelDataTitle({Color? color}) {
    return TextStyle(
      fontSize: 16,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelDataTahun({Color? color, FontWeight? weight}) {
    return TextStyle(
      fontSize: 12,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: weight == null ? FontWeight.w500 : weight,
    );
  }

  static TextStyle data({Color? color}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle description({Color? color, String? italic}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      fontStyle: italic == 'true' ? FontStyle.italic : null,
    );
  }

  static TextStyle descriptionLong({Color? color, String? italic}) {
    return TextStyle(
      fontSize: 15,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      fontStyle: italic == 'true' ? FontStyle.italic : null,
      height: 1.8,
    );
  }

  static TextStyle readPage({Color? color, String? italic}) {
    return TextStyle(
      fontSize: 18,
      color: color ?? Colors.black,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      fontStyle: italic == 'true' ? FontStyle.italic : null,
      height: 1.8,
      letterSpacing: 0.25,
    );
  }
}
