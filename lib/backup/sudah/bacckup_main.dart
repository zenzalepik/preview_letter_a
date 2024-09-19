import 'package:flutter/material.dart';
import 'package:letter_a/pages/ErrorPage.dart';
import 'package:letter_a/pages/user/admin/admin_main_page.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_page.dart';
import 'package:letter_a/pages/sign_up_new_account_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userToken = '';
  String role = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearData();
    checkToken();
  }

  Future<void> clearData() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('userId', '');
    // prefs.setString('userPortfolio', '');
    // prefs.setString('successRegister', '');
    // prefs.setString('token', '');
    // prefs.setString('role', '');
    // prefs.clear();
  }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys(); // Mengambil semua kunci dari SharedPreferences

    for (String key in keys) {
      final value = prefs.get(key); // Mengambil nilai dari kunci
      print('SharedPreferences ==> $key: $value'); // Mencetak kunci dan nilai
    }
    setState(() {
      userToken = prefs.getString('token') ?? '';
      role = prefs.getString('role') ?? '';
    });
    print('token $userToken');
    print('role $role');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letter A | Your Vurtual Assistant From Indonesia',
      theme: ThemeData(
          // your theme data here
          ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420, // Atur lebar maksimum sesuai kebutuhan Anda
        ),
        child: userToken == ''
            // && userToken == null && userToken == 'null'
            ? SignUpNewAccountPage()
            : role == 'admin'
                ? AdminMainPage()
                : role == 'va'
                    ? FreeMainPage()
                    : role == 'client'
                        ? MainPage()
                        : ErrorPage(),
      ),
    );
  }
}
