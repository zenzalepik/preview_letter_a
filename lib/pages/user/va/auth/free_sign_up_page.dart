import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/va/auth/free_login_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_work_experience_page.dart';
import 'package:letter_a/pages/user/va/auth/google/sign_in_with_google.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeSignUpPage extends StatefulWidget {
  const FreeSignUpPage({super.key});

  @override
  State<FreeSignUpPage> createState() => _FreeSignUpPageState();
}

class _FreeSignUpPageState extends State<FreeSignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailRegisSementaraController =
      TextEditingController();
  final TextEditingController _passwordRegisSementaraController =
      TextEditingController();
  final TextEditingController _ulangiPasswordRegisSementaraController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    isRegistered();
  }

  Future<void> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('userId') ?? '';
    print('idUser $idUser');
    if (idUser != '' && idUser != null) {
      String userPortfolio = prefs.getString('userPortfolio') ?? '';
      String isSuccessRegister = prefs.getString('successRegister') ?? '';
      if (isSuccessRegister != '' && isSuccessRegister != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FreeMainPage()),
          (Route<dynamic> route) => false,
        );
      } else if (userPortfolio != '' && userPortfolio != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FreeSignUpWorkExperiencePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FreeSignUpPortfolioPage()),
        );
      }
    }
  }

  Future<void> regisSementara() async {
    final prefs = await SharedPreferences.getInstance();
    String email = _emailRegisSementaraController.text;
    String password = _passwordRegisSementaraController.text;
    setState(() {
      prefs.setString('emailRegisSementara', email);
      prefs.setString('passwordRegisSementara', password);
      // print('${prefs.getString('passwordRegisSementara') ?? ''}');
      // _passwordRegisSementaraController.text =
      // prefs.getString('passwordRegisSementara') ?? '';
    });
  }

  Future<void> checkPassword() async {
    if (_passwordRegisSementaraController.text ==
            _ulangiPasswordRegisSementaraController.text &&
        _passwordRegisSementaraController.text.isNotEmpty &&
        _ulangiPasswordRegisSementaraController.text.isNotEmpty &&
        _emailRegisSementaraController.text.isNotEmpty) {
      await regisSementara();
      print('${_emailRegisSementaraController.text}');
      print('${_passwordRegisSementaraController.text}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreeSignUpPersonalDataPage()),
      );
    } else {
      print("Please enter the email or password correctly.");
      _showError('Please enter the email or password correctly.');
    }
  }

  void _showError(String message) {
    print(message);
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
          title: "Sign Up",
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
              Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: LColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Warna bayangan
                                spreadRadius:
                                    5, // Seberapa jauh bayangan menyebar
                                blurRadius: 7, // Seberapa kabur bayangan
                                offset: Offset(
                                    0, 3), // Perpindahan bayangan dari konten
                              ),
                            ],
                          ),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('As Virtual Assistant (VA)',
                                style: LText.description(color: LColors.white)),
                          )))),
                ],
              ),
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/img_va_sign_up_page.png',
                  fit:
                      BoxFit.contain, // Atur fit agar gambar tetap proporsional
                ),
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: LColors.primary),
                  child: Text("Get Your Dream Job as Virtual Assistant",
                      style: LText.H3(color: LColors.white))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailRegisSementaraController,
                            onChanged: (text) {
                              // setState(() {
                              //   _inputText = text;
                              // });
                            },
                            decoration: InputDecoration(
                              hintText: 'andisetiabudi@gmail.com',
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordRegisSementaraController,
                            onChanged: (text) {
                              // setState(() {
                              //   _password = text;
                              // });
                            },
                            obscureText:
                                true, // Mengatur input sebagai kata sandi
                            decoration: InputDecoration(
                              hintText: '********',
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ulangiPasswordRegisSementaraController,
                            onChanged: (text) {
                              // setState(() {
                              //   _password = text;
                              // });
                            },
                            obscureText:
                                true, // Mengatur input sebagai kata sandi
                            decoration: InputDecoration(
                              hintText: '********',
                              labelText: 'Repeat Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: () {
                              checkPassword();
                            },
                            text: 'NEXT',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("You can sign up with", style: LText.description()),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FreeStartSignInGoogle()),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/icon_google.svg',
                            width: 40, // atur lebar gambar sesuai kebutuhan Anda
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_facebook.svg',
                          width: 40, // atur lebar gambar sesuai kebutuhan Anda
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FreeLoginPage()),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: LText.description(),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                                text: "Login as Virtual Assistant",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
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
    );
  }
}
