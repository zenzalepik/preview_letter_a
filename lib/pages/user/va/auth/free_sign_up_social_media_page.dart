import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_photo_profile_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:letter_a/pages/user/va/home/free_home_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeSignUpSocialMediaPage extends StatefulWidget {
  const FreeSignUpSocialMediaPage({super.key});

  @override
  State<FreeSignUpSocialMediaPage> createState() =>
      _FreeSignUpSocialMediaPageState();
}

class _FreeSignUpSocialMediaPageState extends State<FreeSignUpSocialMediaPage> {
  final TextEditingController _facebookRegisSementaraController =
      TextEditingController();
  final TextEditingController _instagramRegisSementaraController =
      TextEditingController();
  final TextEditingController _linkedinRegisSementaraController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isChecked = false;

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('facebookRegisSementara', '');
    prefs.setString('instagramRegisSementara', '');
    prefs.setString('linkedinRegisSementara', '');
  }

  Future<void> regisSementara2() async {
    final prefs = await SharedPreferences.getInstance();
    String facebook = _facebookRegisSementaraController.text;
    String instagram = _instagramRegisSementaraController.text;
    String linkedin = _linkedinRegisSementaraController.text;

    setState(() {
      prefs.setString('facebookRegisSementara', facebook);
      prefs.setString('instagramRegisSementara', instagram);
      prefs.setString('linkedinRegisSementara', linkedin);
      // print('${prefs.getString('passwordRegisSementara') ?? ''}');
      // _passwordRegisSementaraController.text =
      // prefs.getString('passwordRegisSementara') ?? '';
    });
  }

  Future<void> _submitForm() async {
    final prefs = await SharedPreferences.getInstance();

    await checkData();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> checkData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_facebookRegisSementaraController.text.isEmpty ||
        _instagramRegisSementaraController.text.isEmpty ||
        _linkedinRegisSementaraController.text.isEmpty) {
      _showError('Please fill in all the data correctly.');
      return;
    } else {
      await regisSementara2();
      print('${prefs.getString('facebookRegisSementara') ?? ''}');
      print('${prefs.getString('instagramRegisSementara') ?? ''}');
      print('${prefs.getString('linkedinRegisSementara') ?? ''}');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreePhotoProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: LColors.background,
        appBar: LAppBar(
          title: "Social Media",
          bgColor: LColors.black,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          controller: _facebookRegisSementaraController,
                          labelText: 'Facebook',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          controller: _instagramRegisSementaraController,
                          labelText: 'Instagram',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          controller: _linkedinRegisSementaraController,
                          labelText: 'LinkedIn',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    GapCInput(),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: RoundedElevatedButton(
                            color: LColors.transparentPrimary,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'BACK',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: _submitForm,
                            text: 'NEXT',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
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
}
