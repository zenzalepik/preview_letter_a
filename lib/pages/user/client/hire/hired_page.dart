import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/hire/end_collaboration_alert.dart';
import 'package:letter_a/pages/user/client/hire/will_hire_alert.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HiredPage extends StatefulWidget {
  final String userIdVa;
  final String applicationDescription;
  final String applicationTitle;
  HiredPage(
      {super.key,
      required this.userIdVa,
      required this.applicationDescription,
      required this.applicationTitle});

  @override
  State<HiredPage> createState() => _HiredPageState();
}

class _HiredPageState extends State<HiredPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _uploadedPortfolios = [];
  late Map<String, dynamic> userProfile = {};
  bool isLoading = true;

  List<dynamic> workExperiences = [];
  String vaID = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchWorkExperiences();
    _fetchPortfolios();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    final String role = prefs.getString('role') ?? '';
    print('Token yang dikirim: $token');
    try {
      final response = await http.post(
        Uri.parse('$server/api/v1/api_detail_va.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': widget.userIdVa,
        }),
      );

      print('ID VAAAAAAAAAAAAAA ${widget.userIdVa}');
      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            vaID = "${widget.userIdVa}";
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

    if (widget.userIdVa.isEmpty) {
      _showError("User ID not found.");
      return;
    }

    var uri = Uri.parse(
        "$server/api/v1/api_get_portfolios.php?userId=${widget.userIdVa}");
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
    // String strUserId = prefs.getString('userId') ?? '';
    // int? userId = int.tryParse(strUserId);
    print('WE ${widget.userIdVa}');
    if (widget.userIdVa == null) {
      showError('Invalid User ID');
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          '$server/api/v1/api_get_work_experiences.php?user_id=${widget.userIdVa}'));
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

    print('id VA ${widget.userIdVa}');
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
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
        backgroundColor: LColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(color: LColors.secondary),
                      child: Stack(
                        children: [
                          // SVG sebagai latar belakang
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: SvgPicture.asset(
                              'assets/icons/img_background_hired.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Isi kontainer di atas latar belakang
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Your Offer Has Been Sent to",
                                    // Text("You're working with Andi",
                                    textAlign: TextAlign.center,
                                    style: LText.H3(color: LColors.white)),
                                SizedBox(height: 32),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: userProfile['profileImage'] != null
                                      ? Image.network(
                                          width: 120,
                                          height: 120,
                                          '$server/api/v1/${userProfile['profileImage']}',
                                          fit: BoxFit
                                              .cover, // Atur fit agar gambar tetap proporsional
                                        )
                                      : Image.network(
                                          width: 120,
                                          height: 120,
                                          'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433_1280.png',
                                          fit: BoxFit.cover),
                                ),
                                SizedBox(height: 12),
                                Text("${userProfile['fullName']}",
                                    textAlign: TextAlign.center,
                                    style:
                                        LText.subtitle(color: LColors.white)),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("Project Title",
                                    textAlign: TextAlign.left,
                                    style: LText.subtitle(
                                        // color: LColors.white
                                        )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text("${widget.applicationTitle}",
                                    textAlign: TextAlign.left,
                                    style: LText.description(
                                        // color: LColors.white
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text("Description",
                                    textAlign: TextAlign.left,
                                    style: LText.subtitle(
                                        // color: LColors.white
                                        )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text('''
${widget.applicationDescription}
''',
                                    textAlign: TextAlign.left,
                                    style: LText.description(
                                        // color: LColors.white
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RoundedElevatedButton(
                                  onPressed: () {
                                    // _alertHire(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()),
                                      (route) => false,
                                    );
                                  },
                                  // text: 'End The Collaboration',
                                  text: 'Back to Home',
                                ),
                              )
                            ],
                          )
                        ],
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
    ;
  }

  void _alertHire(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return endHireVA();
      },
    );
  }
}
