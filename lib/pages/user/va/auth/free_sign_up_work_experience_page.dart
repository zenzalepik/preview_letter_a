import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/work_experience_model.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_social_media_page.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/form_work_experience_widget.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FreeSignUpWorkExperiencePage extends StatefulWidget {
  const FreeSignUpWorkExperiencePage({super.key});

  @override
  State<FreeSignUpWorkExperiencePage> createState() =>
      _FreeSignUpWorkExperiencePageState();
}

class _FreeSignUpWorkExperiencePageState
    extends State<FreeSignUpWorkExperiencePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isChecked = false;
  List<WorkExperience> experiences = [
    WorkExperience(
        yearStart: '${DateTime.now().year.toString()}',
        yearEnd: '${DateTime.now().year.toString()}',
        jobTitle: '',
        company: '',
        description: '')
  ];
  List<String> years = generateYearsList();

  void addExperience() {
    setState(() {
      experiences.add(WorkExperience(
          yearStart: '${DateTime.now().year.toString()}',
          yearEnd: '${DateTime.now().year.toString()}',
          jobTitle: '',
          company: '',
          description: ''));
    });
  }

  void submitForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUserId = await prefs.getString('userId') ?? '';
    int? userId = int.tryParse(strUserId);
    List<Map<String, dynamic>> data =
        experiences.map((exp) => exp.toJson(userId!)).toList();

    final response = await http.post(
      Uri.parse('$server/api/v1/api_save_work_experience.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('200');

      try {
        final decodedResponse = json.decode(response.body);
        print('Decoded response: $decodedResponse');

        if (decodedResponse is List) {
          for (var item in decodedResponse) {
            if (item is Map<String, dynamic>) {
              print('Status: ${item['status']}');
              print('Message: ${item['message']}');
              ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text('Your registration is ${item['status']}'),
                  backgroundColor: LColors.primary,
                ),
              );
              prefs.setString('successRegister', 'success');
            } else {
              print('Error: Item in response is not a JSON object');
              _showError('Invalid item format in response');
              return;
            }
          }

          print('Success: ${response.body}');

          Future.delayed(Duration(seconds: 2), () {
            print('Navigating to FreeMainPage...');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreeMainPage()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          print('Error: Response is not a JSON list');
          _showError('Invalid response format');
        }
      } catch (e) {
        print('Exception caught: $e');
        _showError('Error parsing response');
      }
    } else {
      print('Error: ${response.statusCode}');
      _showError('Failed to submit data');
    }
  }

  Future<void> send() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isChecked) {
      _showError('You must agree to the terms and conditions.');
      return;
    } else {
      submitForm();
    }
  }

  void _showError(String message) {
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
          title: "Work Experiences",
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...experiences.map((experience) {
                      return ExperienceForm(
                        experience: experience,
                        years: years,
                        onRemove: () {
                          setState(() {
                            experiences.remove(experience);
                          });
                        },
                      );
                    }).toList(),
                    GapCInput(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 188,
                          child: RoundedElevatedButtonSmall(
                            color: LColors.transparentPrimary,
                            onPressed: addExperience,
                            text: '+ Add Experience',
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    GapCInput(),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: CheckboxWidget(
                            label: '',
                            initialValue: _isChecked,
                            onChanged: (bool value) {
                              // Tindakan yang diambil ketika nilai checkbox berubah
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            style: LText.description(),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                  text: "Terms and Conditions",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: RoundedElevatedButton(
                            color: LColors.transparentPrimary,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'BACK',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: send,
                            text: 'Finish',
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

List<String> generateYearsList() {
  int currentYear = DateTime.now().year;
  List<String> years = [];
  for (int year = 1945; year <= currentYear; year++) {
    years.add(year.toString());
  }
  return years.reversed.toList();
}
