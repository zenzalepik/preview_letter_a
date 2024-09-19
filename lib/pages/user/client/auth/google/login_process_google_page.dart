import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBerhasil extends StatefulWidget {
  final String? emailClient;
  final String? passwordClient;
  LoginBerhasil({Key? key, this.emailClient, this.passwordClient})
      : super(key: key);

  @override
  State<LoginBerhasil> createState() => _LoginBerhasilState();
}

class _LoginBerhasilState extends State<LoginBerhasil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String apiUrl = '$server/api/v1/api_login.php';
  String isError = '';

  @override
  void initState() {
    super.initState();
    inisiasi();
  }

  Future<void> inisiasi() async {
    if ((widget.emailClient != '' &&
            widget.emailClient != 'null' &&
            widget.emailClient != null) &&
        (widget.passwordClient != '' &&
            widget.passwordClient != 'null' &&
            widget.passwordClient != null)) {
      await login(widget.emailClient!, widget.passwordClient!);
    } else {
      setState(() {
        isError = 'We are sorry, something went wrong';
      });
    }
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
          final String userName = '${responseData['fullName'] ?? ''}';
          final String profileImage = '${responseData['profileImage'] ?? ''}';

          if (role == 'client') {
            print('>>>>>>>>>>>>>>>>>>>>> userName $userName');
            prefs.setString('token', token);
            prefs.setString('role', role);
            prefs.setString('userId', userId);
            prefs.setString('userName', userName);
            prefs.setString('profileImage', profileImage);
            print('Login user id ${prefs.getString('userId') ?? ''}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              (route) => false,
            );
          } else {
            _showError("You haven't registered as a client yet");
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
    return Text(isError == ''
        ? '${widget.emailClient} Login Berhasil ${widget.passwordClient}'
        : '$isError');
  }
}
