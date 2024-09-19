import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_work_experience_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FreeSignUpPortfolioPage extends StatefulWidget {
  const FreeSignUpPortfolioPage({super.key});

  @override
  State<FreeSignUpPortfolioPage> createState() =>
      _FreeSignUpPortfolioPageState();
}

class _FreeSignUpPortfolioPageState extends State<FreeSignUpPortfolioPage> {
  @override
  void initState() {
    super.initState();
  }

  List<File> _files = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _files = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<void> _uploadFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      _showError("User ID not found.");
      return;
    }

    var uri = Uri.parse("$server/api/v1/api_upload_portfolio.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['userId'] = userId;

    for (var file in _files) {
      request.files.add(await http.MultipartFile.fromPath(
        'files[]',
        file.path,
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody'); // Cetak respons untuk debugging

        List<dynamic> responseJson = jsonDecode(responseBody);

        for (var item in responseJson) {
          // _showError('${item['message']}'); // Cetak pesan dari API
        }

        bool allSuccess =
            responseJson.every((item) => item['status'] == 'success');

        if (allSuccess) {
          prefs.setString('userPortfolio', 'inserted');
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Files uploaded successfully'),
              backgroundColor: LColors.primary,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FreeSignUpWorkExperiencePage(),
            ),
          );
        } else {
          _showError("Failed to upload some files. Please try again.");
        }
      } else {
        _showError(
            "Failed to upload files. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // _showError("An error occurred during file upload: $e");
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
          title: "Portfolio",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: LColors.primary),
                child: Text(
                    'Your account is already registered. Please complete further details',
                    textAlign: TextAlign.center,
                    style: LText.description(color: LColors.white)),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(24),
                            strokeWidth: 2,
                            color: LColors.primary,
                            dashPattern: [8, 4],
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 56),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color.fromARGB(55, 0, 152, 15)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/icon_file.svg',
                                        color: LColors.primary,
                                        width: 80,
                                      ),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      SvgPicture.asset(
                                        'assets/icons/icon_image.svg',
                                        color: LColors.primary,
                                        width: 80,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  IconButtonWidget(
                                    onPressed: _pickFiles,
                                    icon: 'icon_upload.svg',
                                    text: 'Upload',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _files.isNotEmpty
                        ? Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _files.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              child: Text('$index.',
                                                  style: LText.button(
                                                      color: LColors.primary)),
                                            ),
                                            Expanded(
                                              child: Text(_files[index]
                                                  .path
                                                  .split('/')
                                                  .last),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Divider(
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Container(),
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
                            onPressed: _uploadFiles,
                            text: 'NEXT',
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
