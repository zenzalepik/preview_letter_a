import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
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
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FreePhotoProfilePage extends StatefulWidget {
  const FreePhotoProfilePage({super.key});

  @override
  State<FreePhotoProfilePage> createState() => _FreePhotoProfilePageState();
}

class _FreePhotoProfilePageState extends State<FreePhotoProfilePage> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initFirst();
  }

  Future<void> initFirst() async {}

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();
    String base64Image = '';
    String fileName = '';
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      base64Image = base64Encode(imageBytes);
      fileName = _image!.path.split('/').last;
    }

    final response = await http.post(
      Uri.parse('$server/api/v1/api_register.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': prefs.getString('emailRegisSementara') ?? '',
        'password': prefs.getString('passwordRegisSementara') ?? '',
        'fullName': prefs.getString('namaLengkapRegisSementara') ?? '',
        'placeOfBirth': prefs.getString('tempatLahirRegisSementara') ?? '',
        'dateOfBirth': DateFormat('d/M/yyyy')
                .parse(prefs.getString('tanggalLahirRegisSementara') ?? '')
                .toIso8601String() ??
            '',
        'whatsapp': prefs.getString('whatsappRegisSementara') ?? '',
        'ijazah': prefs.getString('ijazahRegisSementara') ?? '',
        'facebook': prefs.getString('facebookRegisSementara') ?? '',
        'instagram': prefs.getString('instagramRegisSementara') ?? '',
        'linkedIn': prefs.getString('linkedinRegisSementara') ?? '',
        'role': 'va',
        'profileImage': {
          'name': fileName,
          'data': base64Image,
        },
        'city': prefs.getString('kotaTinggalRegisSementara') ?? '',
        'province': prefs.getString('provinsiTinggalRegisSementara') ?? '',
      }),
    );

    final data = jsonDecode(response.body);
    print('Response from API: $data'); // Mencetak semua data respons ke konsol

    if (data['status'] == 'success') {
      prefs.setString('userId', data['user_profile']['id']);

      String userId = prefs.getString('userId') ?? '';
      String profileImage = prefs.getString('profileImage') ?? '';

      print('userId: $userId'); // Cetak ID pengguna ke konsol
      print('profileImage: $profileImage'); // Cetak ID pengguna ke konsol

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text('${data['message']}')),
        // content: Text('User ID: $userId')),
      );
      // Navigasi ke halaman lain jika diperlukan
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreeSignUpPortfolioPage()),
      );
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(backgroundColor: LColors.red, content: Text(data['message'])),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> registerNow() async {
    if (_image != null) {
      await _register();
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
            backgroundColor: LColors.red,
            content: Text('Please upload your photo profile first')),
      );
    }
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
          title: "Photo Profile",
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
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SizedBox(
                              width: 320,
                              height: 320,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(24),
                                strokeWidth: 2,
                                color: LColors.primary,
                                dashPattern: [8, 4],
                                child: Container(
                                  padding: _image == null
                                      ? EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 56)
                                      : EdgeInsets.all(0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color.fromARGB(55, 0, 152, 15),
                                    image: _image == null
                                        ? null
                                        : DecorationImage(
                                            image: FileImage(
                                              _image!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          _image == null
                                              ? Padding(
                                                  padding: _image == null
                                                      ? const EdgeInsets.all(0)
                                                      : EdgeInsets.fromLTRB(
                                                          24, 56, 24, 0),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/icon_image.svg',
                                                    color: LColors.primary,
                                                    width: 80,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 56,
                                      ),
                                      Padding(
                                        padding: _image == null
                                            ? EdgeInsets.all(0)
                                            : EdgeInsets.fromLTRB(
                                                24, 120, 24, 56),
                                        child: IconButtonWidget(
                                          onPressed: _pickImage,
                                          icon: 'icon_upload.svg',
                                          text: _image == null
                                              ? 'Upload'
                                              : 'Change Image',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
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
                            onPressed: registerNow,
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
