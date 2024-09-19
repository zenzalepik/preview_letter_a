import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_work_experience_page.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:letter_a/pages/user/va/profile/free_profile_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FreeLoginPage extends StatefulWidget {
  const FreeLoginPage({super.key});

  @override
  State<FreeLoginPage> createState() => _FreeLoginPageState();
}

class _FreeLoginPageState extends State<FreeLoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String apiUrl = '$server/api/v1/api_login.php';

  @override
  void initState() {
    super.initState();
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print('Server response status: ${response.statusCode}');
    print('Server response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        if (response.body.isEmpty) {
          _showError('Empty response from server.');
          return;
        }

        final responseData = jsonDecode(response.body);
        print('Response: $responseData');

        if (responseData['status'] == 'success') {
          final String token = responseData['token'];
          final String role = responseData['role'];
          final String userId = responseData['userId'];
          final String userName = "${responseData['fullName'] ?? ''}";
          final String profileImage = "${responseData['profileImage'] ?? ''}";
          print('>>>>>>>>>>>>>>>>>>>>> userName $userName');

          if (role == 'va') {
            prefs.setString('token', token);
            prefs.setString('role', role);
            prefs.setString('userId', userId);
            prefs.setString('userName', userName);
            prefs.setString('profileImage', profileImage);

            print('Login user id ${prefs.getString('userId') ?? ''}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreeMainPage()),
              (route) => false,
            );
          } else {
            _showError("You haven't registered as a VA yet");
          }
        } else {
          _showError(responseData['message']);
        }
      } catch (e) {
        print('Error parsing response: $e');
        _showError('Failed to parse response. Please try again.');
      }
    } else {
      _showError('Failed to login. Please try again.');
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
          title: "Login",
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
                constraints: BoxConstraints(maxHeight: 220),
                child: Image.asset(
                  'assets/images/img_va_sign_up.png',
                  fit: BoxFit.cover, // Atur fit agar gambar tetap proporsional
                ),
              ),
              // Container(
              //     padding: EdgeInsets.all(16),
              //     decoration: BoxDecoration(color: LColors.primary),
              //     child: Text("Get Your Dream Job as Virtual Assistant",
              //         style: LText.H3(color: LColors.white))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
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
                            controller: _passwordController,
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
                          child: RoundedElevatedButton(
                            onPressed: () {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              login(email, password);
                            },
                            text: 'LOGIN',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("You can sign in with", style: LText.description()),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/icon_google.svg',
                          width: 40, // atur lebar gambar sesuai kebutuhan Anda
                          fit: BoxFit.contain,
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
                        Navigator.pop(context);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: LText.description(),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Don't have an account yet? ",
                              style: TextStyle(),
                            ),
                            TextSpan(
                                text: "Signup as Virtual Assistant",
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
