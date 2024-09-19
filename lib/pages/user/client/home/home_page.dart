import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/client/home/search_va_page.dart';
import 'package:letter_a/pages/user/client/notification/client_list_notification.dart';
import 'package:letter_a/pages/user/client/va/va_detail_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> users = [];
  bool isLoading = true;
  String token = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> printSharedPreferences() async {
    // Ambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$server/api/v1/api_list_users.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == 'success') {
          setState(() {
            users = data['users'];
            isLoading = false;
          });
          print('banyak user ${users.length},');
        } else {
          _showError(data['message']);
        }
      } else {
        _showError('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Failed to fetch users: $e');
    }
  }

  void _showError(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
        body: isLoading
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
                                      'Your Virtual Assistance in Indonesia',
                                      style: LText.description(
                                          color: LColors.white)),
                                )))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchVAPage()),
                                );
                              },
                              child: AbsorbPointer(
                                child: CustomSearchBar(
                                  hintText: 'Pencarian...',
                                  onChanged: (value) {
                                    // Tindakan yang diambil ketika nilai pencarian berubah
                                  },
                                  onSubmitted: (value) {
                                    // Tindakan yang diambil ketika pengguna menekan tombol submit
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Jumlah kolom
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 6.0,
                            childAspectRatio: 0.75, // Sesuaikan aspek rasio
                          ),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            double rating =
                                double.tryParse(user['rating'].toString()) ??
                                    0.0;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VADetailPage(
                                            userIdVa: '${user['id']}',
                                          )),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                shadowColor: Colors.grey.withOpacity(0.24),
                                color: Colors.greenAccent[100],
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: user['profileImage'] !=
                                                          null
                                                      ? Image.network(
                                                          '$server/api/v1/${user['profileImage']}',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433_1280.png',
                                                          fit: BoxFit.cover),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "${user['fullName']}",
                                                          style: LText
                                                              .labelDataTitle(
                                                                  color: LColors
                                                                      .black)),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 16,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/icons/icon_star_yellow.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text("$rating"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 40)
                  ],
                ),
              ),
      ),
    );
  }
}
