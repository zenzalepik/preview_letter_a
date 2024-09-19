import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/hire/will_hire_alert.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/va/chat_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        backgroundColor: LColors.background,
        appBar: LAppBar(
          title: "Terms and Conditions",
          bgColor: LColors.primary,
          actions: <Widget>[],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              'assets/icons/icon_back.svg',
              width: 200, // atur lebar gambar sesuai kebutuhan Anda
              height: 200, // atur tinggi gambar sesuai kebutuhan Anda
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin quis diam id velit efficitur pulvinar. Sed feugiat, ligula et viverra mattis, nulla erat semper mauris, eu ornare diam massa vitae nulla. Curabitur erat ante, sodales eget tincidunt eget, pretium et leo. Pellentesque quis faucibus mi. Donec non velit rutrum, iaculis neque nec, euismod mauris. Nam et nunc ornare, bibendum nibh ut, pulvinar ante. Ut auctor metus in nisi blandit, id finibus dolor blandit. Morbi nibh nunc, hendrerit ut quam at, accumsan congue dui. Nam malesuada vehicula elit sed tristique. Praesent fermentum, lacus eu viverra aliquam, tortor mi aliquet turpis, sed consequat dui tellus ac diam. Fusce faucibus cursus quam et mattis. Donec id convallis nunc. Mauris cursus euismod arcu vel iaculis. Donec iaculis, odio ac maximus dignissim, mi dolor finibus mauris, non euismod enim turpis a libero. Proin venenatis neque eget erat venenatis, nec vulputate dolor interdum. Nulla posuere turpis id efficitur hendrerit.''',
                                style: LText.readPage())),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _alertHire(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return willHireVA(vaID: '',);
      },
    );
  }
}
