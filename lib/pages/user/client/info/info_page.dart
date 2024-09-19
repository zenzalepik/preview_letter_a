import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/info/data_protexttion_page.dart';
import 'package:letter_a/pages/info/imprint_page.dart';
import 'package:letter_a/pages/info/terms_and_onditions_page.dart';
import 'package:letter_a/pages/user/client/notification/client_list_notification.dart';
import 'package:letter_a/pages/user/client/va/va_detail_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:letter_a/widgets/menu_arrow_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String token = '';

  @override
  void initState() {
    super.initState();
    printSharedPreferences();
  }

  Future<void> printSharedPreferences() async {
    // Ambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        backgroundColor: LColors.background,
        appBar: AppBar(
          backgroundColor: LColors.secondary,
          title: Center(
            child: Image.asset('assets/images/img_logo_transparent_white.png',
                width: 120),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.notifications_active_outlined,
                    color: LColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientNotificationListPage(
                        token: token,
                      ),
                    ),
                  );
                })
          ],
          leading: IconButton(
              icon: Icon(Icons.notifications_active_outlined,
                  color: LColors.secondary),
              onPressed: () {}),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          color: LColors.primary,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Info',
                                style: LText.description(color: LColors.white)),
                          )))),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(children: [
                    MenuArrowWidget(
                        text: 'Imprint',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImprintPage()),
                          );
                        }),
                    MenuArrowWidget(
                        text: 'Data Protection',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataProtectionPage()),
                          );
                        }),
                    MenuArrowWidget(
                        text: 'Terms and Conditions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditionsPage()),
                          );
                        })
                  ])),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
