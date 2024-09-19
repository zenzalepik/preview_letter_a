import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/hire/will_hire_alert.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/va/chat_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/sign_up_new_account_page.dart';
import 'package:letter_a/pages/user/va/notification/free_list_notification.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FreeMyProfilePage extends StatefulWidget {
  const FreeMyProfilePage({super.key});

  @override
  State<FreeMyProfilePage> createState() => _FreeMyProfilePageState();
}

class _FreeMyProfilePageState extends State<FreeMyProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _uploadedPortfolios = [];
  late Map<String, dynamic> userProfile = {};
  bool isLoading = true;

  List<dynamic> workExperiences = [];

  String token = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchWorkExperiences();
    _fetchPortfolios();
    printSharedPreferences();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    final String role = prefs.getString('role') ?? '';
    print('Token yang dikirim: $token');
    try {
      final response = await http.post(
        Uri.parse('$server/api/v1/api_profile.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
        }),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userProfile = data;
            isLoading = false;
          });
        } else {
          _showError(data['message']);
        }
      } else {
        // Tangani berbagai status kode HTTP dan respons tidak valid
        _showError('Failed to fetch profile. Please try again.');
      }
    } catch (e) {
      _showError('Failed to parse server response.');
      print('Error parsing JSON: $e');
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fetchPortfolios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      _showError("User ID not found.");
      return;
    }

    var uri = Uri.parse("$server/api/v1/api_get_portfolios.php?userId=$userId");
    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        print(
            "Response body: ${response.body}"); // Debugging: print response body
        // _showError(
        //     "Response body: ${response.body}"); // Show response body in SnackBar

        setState(() {
          _uploadedPortfolios = json.decode(response.body);
        });

        // _showPortfoliosSnackBar();
      } else {
        print(
            "Failed to fetch portfolios. Status code: ${response.statusCode}");
      }
    } catch (e) {
      _showError("An error occurred while fetching portfolios: $e");
    }
  }

  void _showPortfoliosSnackBar() {
    if (_uploadedPortfolios.isNotEmpty) {
      String messagesString = jsonEncode(_uploadedPortfolios);
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(messagesString),
          backgroundColor: LColors.primary,
        ),
      );
    } else {
      _showError("No portfolios found.");
    }
  }

  Future<void> fetchWorkExperiences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUserId = prefs.getString('userId') ?? '';
    int? userId = int.tryParse(strUserId);
    print('WE $strUserId');
    if (userId == null) {
      showError('Invalid User ID');
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          '$server/api/v1/api_get_work_experiences.php?user_id=$strUserId'));
      print("hit Api");
      if (response.statusCode == 200) {
        print("hit 200");
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          print("sukses");
          setState(() {
            workExperiences = data['data'];
            isLoading = false;
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError('Failed to load work experiences');
      }
    } catch (e) {
      showError('An error occurred while fetching data');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
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
                      builder: (context) => VANotificationListPage(
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
                                      'Profile Account (As Virtual Assistant)',
                                      style: LText.description(
                                          color: LColors.white)),
                                )))),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: LColors.white),
                                  borderRadius: BorderRadius.circular(60)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: userProfile['profileImage'] != null &&
                                        userProfile['profileImage']
                                                .toString()
                                                .length >
                                            25
                                    ? Image.network(
                                        '$server/api/v1/${userProfile['profileImage']}',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433_1280.png',
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      '${userProfile['fullName']}',
                                      style: LText.H05()))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      '${userProfile['email']}',
                                      style: LText.description()))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 24,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                  "${userProfile['rating'] == '' || userProfile['rating'] == null || userProfile['rating'] == 'null' ? 5.0 : userProfile['rating']}",
                                  style: LText.subtitle(color: LColors.black))
                            ],
                          ),
                          GapCInput(),
                          Divider(color: LColors.line),
                          GapCInput(),

                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('City of residence',
                                            style: LText.labelData()),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('${userProfile['city']}',
                                              style: LText.data())),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          GapCInput(),

                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Province of residence',
                                            style: LText.labelData()),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${userProfile['province']}',
                                              style: LText.data())),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          GapCInput(),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Date of birth',
                                              style: LText.labelData())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${userProfile['dateOfBirth']}',
                                              style: LText.data())),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          GapCInput(),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Whatsapp',
                                              style: LText.labelData())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${userProfile['whatsapp']}',
                                              style: LText.data())),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          GapCInput(),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Email',
                                              style: LText.labelData())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('${userProfile['email']}',
                                            style: LText.data()),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          GapCInput(),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Last diploma',
                                              style: LText.labelData())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('${userProfile['ijazah']}',
                                            style: LText.data()),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          // GapCInput(),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child: Column(
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Expanded(
                          //                 child: Text('Last diploma',
                          //                     style: LText.labelData())),
                          //           ],
                          //         ),
                          //         Row(
                          //           children: [
                          //             Expanded(
                          //               child: Text(
                          //                   'Bachelor Degree of Information Systems',
                          //                   style: LText.data()),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     )),
                          //   ],
                          // ),
                          GapCInput(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _uploadedPortfolios.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: _uploadedPortfolios.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Jumlah kolom
                                      mainAxisSpacing: 8.0,
                                      crossAxisSpacing: 6.0,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var portfolio =
                                          _uploadedPortfolios[index];
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) => FreeVADetailPage()),
                                          // );
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.24),
                                          color: Colors.greenAccent[100],
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Image
                                                                      .network(
                                                                    '$server/api/v1/${portfolio['file_path']}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Text("${portfolio['file_path'].substring(18)}")),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                    })
                                : Center(
                                    child: Text("No portfolios found."),
                                  ),
                          ),
                          GapCInput(),
                          Text('Work Experiences', style: LText.H3()),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : workExperiences.isEmpty
                                  ? Center(
                                      child: Text('No work experiences found.'))
                                  : ListView.builder(
                                      itemCount: workExperiences.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var experience = workExperiences[index];
                                        return Column(children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            experience[
                                                                'job_title'],
                                                            style: LText
                                                                .labelData(),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                            '${experience['year_start']} - ${experience['year_end']}',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: LText
                                                                .labelDataTahun(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '${experience['company']}',
                                                            style: LText.data(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Divider(
                                                      thickness: 2,
                                                      color: LColors.line,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]);
                                      }),
                          GapCInput(),
                          Text('Sosial Media', style: LText.H3()),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _launchURL(
                                      'https://id.linkedin.com/in/${userProfile['linked']}');
                                },
                                child: SizedBox(
                                  width: 32,
                                  child: SvgPicture.asset(
                                      'assets/icons/icon_sosial_linkedin.svg'),
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(
                                      'https://instagram.com/${userProfile['instagram']}');
                                },
                                child: SizedBox(
                                  width: 32,
                                  child: SvgPicture.asset(
                                      'assets/icons/icon_sosial_instagram.svg'),
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(
                                      'https://facebook.com/${userProfile['facebook']}');
                                },
                                child: SizedBox(
                                  width: 32,
                                  child: SvgPicture.asset(
                                      'assets/icons/icon_sosial_facebook.svg'),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: LColors.line,
                          ),
                          GapCInput(),
                          SizedBox(
                            height: 16,
                          ),
                          RoundedElevatedButton(
                              onPressed: logOut, text: 'Log Out')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _alertHire(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return willHireVA(vaID: '',);
      },
    );
  }
}
