import 'package:flutter/material.dart';
import 'package:letter_a/pages/sign_up_new_account_page.dart';
import 'package:letter_a/pages/user/admin/notification/admin_detail_notification.dart';
import 'package:letter_a/pages/user/admin/notification/admin_input_notiofication.dart';
import 'package:letter_a/pages/user/admin/notification/admin_list_notification.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? token;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> checkLogin() async {
    await checkToken();
    if (token == '' || token == null || token == 'null') {
      _showError('Token tidak ditemukan');
    } else {}
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

  Future<void> logOut() async {
    await clearData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpNewAccountPage()),
      (route) => false, // Kondisi untuk menghapus semua layar sebelumnya
    );
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', '');
    prefs.setString('userPortfolio', '');
    prefs.setString('successRegister', '');
    prefs.setString('token', '');
    prefs.setString('role', '');
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RoundedElevatedButton(
                        text: 'Create Notification',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminAddNotificationScreen(
                                        token: '$token',
                                      )));
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: RoundedElevatedButton(
                        text: 'List Notification',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminNotificationListScreen(
                                        token: '$token',
                                      )));
                        },
                      ),
                    )
                  ],
                ),
                GapCInput(),
                GapCInput(),
                GapCInput(),
                RoundedElevatedButton(
                  color: LColors.red,
                  colorText: LColors.white,
                  text: 'Log Out',
                  onPressed: logOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
