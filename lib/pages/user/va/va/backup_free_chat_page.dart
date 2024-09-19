import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/hire/will_hire_alert.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';

class FreeVAChatPage extends StatefulWidget {
  const FreeVAChatPage({super.key});

  @override
  State<FreeVAChatPage> createState() => _FreeVAChatPageState();
}

class _FreeVAChatPageState extends State<FreeVAChatPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        backgroundColor: LColors.background,
        appBar: LAppBar(
          title: "Andi Setia Budi",
          bgColor: LColors.primary,
          actions: <Widget>[
            RoundedElevatedButtonWhite(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MainPage()),
                // );
                _alertHire(context);
              },
              text: 'HIRE',
            ),
          ],
          leading: SizedBox(
            width: 200,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_back.svg',
                    width: 32, // atur lebar gambar sesuai kebutuhan Anda
                    height: 32, // atur tinggi gambar sesuai kebutuhan Anda
                  ),
                ),
                SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://media.licdn.com/dms/image/D560BAQGJUG180m_n2Q/company-logo_200_200/0/1685268545987/zalepik_studio_logo?e=2147483647&v=beta&t=eOM6tULFEWgE3BllqOs8ZLNNUAUgldfqiPP1-jayrMA',
                    width: 32, // atur lebar gambar sesuai kebutuhan Anda
                    height: 32, // atur tinggi gambar sesuai kebutuhan Anda
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: double.infinity,
                              child: SvgPicture.asset(
                                'assets/icons/img_chat.svg',
                                fit: BoxFit
                                    .contain, // Atur fit agar gambar tetap proporsional
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: LColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      onChanged: (text) {
                        // setState(() {
                        //   _password = text;
                        // });
                      },
                      // obscureText: true, // Mengatur input sebagai kata sandi
                      decoration: InputDecoration(
                        hintText: 'Type message...',
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 72,
                  child: IconButtonSmallWidget(
                    color: LColors.primary,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MainPage()),
                      // );
                _alertHire(context);
                    },
                    text: '',
                    icon: 'icon_send.svg',
                  ),
                ),
              ],
            ),
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
