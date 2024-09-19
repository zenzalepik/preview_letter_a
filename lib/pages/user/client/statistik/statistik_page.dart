import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
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
import 'package:letter_a/widgets/statistik_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  List _data = [];
  String token = 'b';
  
  @override
  void initState() {
    super.initState();
    _fetchData();
    // gantiToken();
    printSharedPreferences();
  }

  Future<void> printSharedPreferences() async {
    // Ambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }
  // Future<void> gantiToken() async {
  //   setState(() {
  //     token = 'aaa';
  //     print('$token');
  //   });
  // }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse('$server/api/v1/api_statistic_user_va.php'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Berhasil memuat data
      setState(() {
        _data = json.decode(response.body);
      });
      print('Response: ${response.body}'); // Cetak respon API di konsol
    } else {
      // Gagal memuat data
      throw Exception('Failed to load data');
    }
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
        body: _data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                  child: Text(
                                      'Statistik (As Virtual Assistant)',
                                      style: LText.description(
                                          color: LColors.white)),
                                )))),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              final item = _data[index];
                              double userCount;
                              try {
                                userCount =
                                    double.parse(item['user_count'].toString());
                              } catch (e) {
                                userCount =
                                    0.0; // Default value if conversion fails
                              }
                              return StatistikWidget(
                                text:
                                    'Kota ${item['city']} - ${item['province']}',
                                jumlahUser: userCount,
                              );
                            },
                          ),
                        ])),
                    SizedBox(height: 40)
                  ],
                ),
              ),
      ),
    );
  }
}
