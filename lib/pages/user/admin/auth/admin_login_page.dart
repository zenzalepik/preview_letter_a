import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/admin/admin_main_page.dart';
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

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
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
          if (role == 'admin') {
            prefs.setString('token', token);
            prefs.setString('role', role);
            prefs.setString('userId', userId);

            print('Login user id ${prefs.getString('userId') ?? ''}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AdminMainPage()),
              (route) => false,
            );
          } else {
            _showError(responseData['You are not admin!']);
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
                            color: LColors.red,
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
                            child: Text('As Admin',
                                style: LText.description(color: LColors.white)),
                          )))),
                ],
              ),
              Container(
                color: LColors.black,
                padding: EdgeInsets.symmetric(horizontal: 80),
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 220),
                child: Image.asset(
                  'assets/images/img_logo_vertical_color.png',
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
                            text: 'LOGIN ADMIN',
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
