import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/admin/admin_main_page.dart';
import 'package:letter_a/pages/user/admin/auth/admin_login_page.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_page.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/button_image_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpNewAccountPage extends StatefulWidget {
  const SignUpNewAccountPage({super.key});

  @override
  State<SignUpNewAccountPage> createState() => _SignUpNewAccountPageState();
}

class _SignUpNewAccountPageState extends State<SignUpNewAccountPage> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    // Minta izin untuk akses penyimpanan
    await Permission.storage.request();
    var status = await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    var manageExternalStorage =
        await Permission.manageExternalStorage.request();
    await Permission.mediaLibrary.request();
    var mediaLibrary = await Permission.mediaLibrary.request();
    await Permission.accessMediaLocation.request();
    var accessMediaLocation = await Permission.accessMediaLocation.request();
    if (status.isGranted &&
        manageExternalStorage.isGranted &&
        accessMediaLocation.isGranted &&
        mediaLibrary.isGranted) {
      // Izin diberikan, lanjutkan dengan proses download PDF
      // Panggil fungsi untuk mendownload PDF
    } else {
      // Izin ditolak, tampilkan pesan kepada pengguna
      print('Izin akses penyimpanan ditolak');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        backgroundColor: LColors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  width: 80,
                  child: Image.asset(
                    'assets/images/img_logo_vertical_color.png',
                    fit: BoxFit
                        .contain, // Atur fit agar gambar tetap proporsional
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    // decoration: BoxDecoration(color: LColors.primary),
                    child: Text("Your Virtual Assistance in Indonesia",
                        textAlign: TextAlign.center,
                        style: LText.H3(color: LColors.white))),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ButtonImageWidget(
                            text: 'Sign Up As Client',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                          ),
                          SizedBox(height: 24),
                          ButtonImageWidget(
                            text: 'Sign Up As Virtual Asisten',
                            colorButton: LColors.white,
                            imgBg: 'assets/images/img_va_sign_up.png',
                            // colorBg: LColors.secondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FreeSignUpPage()),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedElevatedButton(
                        text: 'Admin',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLoginPage()));
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
