import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/city_and_province_model.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUpPersonalDataPage extends StatefulWidget {
  const SignUpPersonalDataPage({super.key});

  @override
  State<SignUpPersonalDataPage> createState() => _SignUpPersonalDataPageState();
}

class _SignUpPersonalDataPageState extends State<SignUpPersonalDataPage> {
  final TextEditingController _namaLengkapRegisSementaraController =
      TextEditingController();
  final TextEditingController _tempatLahirRegisSementaraController =
      TextEditingController();
  final TextEditingController _tanggalLahirRegisSementaraController =
      TextEditingController();
  final TextEditingController _whatsappRegisSementaraController =
      TextEditingController();
  final TextEditingController _kotaTinggalRegisSementaraController =
      TextEditingController();
  final TextEditingController _provinsiTinggalRegisSementaraController =
      TextEditingController();
  final TextEditingController _facebookRegisSementaraController =
      TextEditingController();
  final TextEditingController _instagramRegisSementaraController =
      TextEditingController();
  final TextEditingController _linkedinRegisSementaraController =
      TextEditingController();

  final String apiLoginUrl = '$server/api/v1/api_login.php';

  String? selectedProvince;
  String? selectedCity;
  List<Province> provinces = [];
  List<City> cities = [];

  @override
  void initState() {
    super.initState();
    fetchProvinces().then((data) {
      setState(() {
        provinces = data;
      });
    });
  }

  Future<List<Province>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://api.rajaongkir.com/starter/province'),
      headers: {'key': '$apiRajaOngkir'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['rajaongkir']['results'];
      return jsonResponse.map((data) => Province.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<City>> fetchCities(String provinceId) async {
    final response = await http.get(
      Uri.parse('https://api.rajaongkir.com/starter/city?province=$provinceId'),
      headers: {'key': '$apiRajaOngkir'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['rajaongkir']['results'];
      return jsonResponse.map((data) => City.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isChecked = false;

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('namaLengkapRegisSementara', '');
    prefs.setString('tempatLahirRegisSementara', '');
    prefs.setString('tanggalLahirRegisSementara', '');
    prefs.setString('whatsappRegisSementara', '');
  }

  Future<void> send() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isChecked) {
      _showError('You must agree to the terms and conditions.');
      return;
    } else {
      _submitForm();
    }
  }

  Future<void> _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    // if (!_isChecked) {
    //   _showError('You must agree to the terms and conditions.');
    //   return;
    // } else {
    await checkData();
    // }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> checkData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_namaLengkapRegisSementaraController.text.isEmpty ||
        _tempatLahirRegisSementaraController.text.isEmpty ||
        _tanggalLahirRegisSementaraController.text.isEmpty ||
        _whatsappRegisSementaraController.text.isEmpty ||
        _facebookRegisSementaraController.text.isEmpty ||
        _instagramRegisSementaraController.text.isEmpty ||
        _linkedinRegisSementaraController.text.isEmpty ||
        _kotaTinggalRegisSementaraController.text.isEmpty ||
        _provinsiTinggalRegisSementaraController.text.isEmpty) {
      _showError('Please fill in all the data correctly.');
      return;
    } else {
      await _register();
    }
  }

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();
    // String base64Image = '';
    // String fileName = '';
    // if (_image != null) {
    //   List<int> imageBytes = await _image!.readAsBytes();
    //   base64Image = base64Encode(imageBytes);
    //   fileName = _image!.path.split('/').last;
    // }

    final response = await http.post(
      Uri.parse('$server/api/v1/api_register.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': prefs.getString('emailRegisSementara') ?? '',
        'password': prefs.getString('passwordRegisSementara') ?? '',
        'fullName': _namaLengkapRegisSementaraController.text,
        'placeOfBirth': _tempatLahirRegisSementaraController.text,
        'dateOfBirth': DateFormat('d/M/yyyy')
            .parse(_tanggalLahirRegisSementaraController.text)
            .toIso8601String(),
        'whatsapp': _whatsappRegisSementaraController.text,
        'ijazah': '',
        'facebook': _facebookRegisSementaraController.text,
        'instagram': _instagramRegisSementaraController.text,
        'linkedIn': _linkedinRegisSementaraController.text,
        'role': 'client',
        // 'profileImage': {
        //   'name': fileName,
        //   'data': base64Image,
        // },
        'profileImage': {
          'name': '',
          'data': '',
        },
        'city': _kotaTinggalRegisSementaraController.text,
        'province': _provinsiTinggalRegisSementaraController.text,
      }),
    );

    final data = jsonDecode(response.body);
    print('Response from API: $data'); // Mencetak semua data respons ke konsol

    if (data['status'] == 'success') {
      prefs.setString('userId', data['user_profile']['id']);

      String userId = prefs.getString('userId') ?? '';

      print('userId: $userId'); // Cetak ID pengguna ke konsol

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text('${data['message']}')),
        // content: Text('User ID: $userId')),
      );
      // Navigasi ke halaman lain jika diperlukan
      String emailLogin = prefs.getString('emailRegisSementara') ?? '';
      String passwordLogin = prefs.getString('passwordRegisSementara') ?? '';
      login(emailLogin, passwordLogin);
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(backgroundColor: LColors.red, content: Text(data['message'])),
      );
    }
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(apiLoginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print('Server response status: ${response.statusCode}');
    print('Server response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        if (response.body.isEmpty) {
          _showError('Empty response from server.');
          return;
        }

        final responseData = jsonDecode(response.body);
        print('Response: $responseData');

        if (responseData['status'] == 'success') {
          final String token = responseData['token'];
          final String role = responseData['role'];
          final String userId = responseData['userId'];
          final String userName = responseData['fullName'];
          final String profileImage = responseData['profileImage'];
          prefs.setString('token', token);
          prefs.setString('role', role);
          prefs.setString('userId', userId);
          prefs.setString('userName', userName);
          prefs.setString('profileImage', profileImage);

          print('Login user id ${prefs.getString('userId') ?? ''}');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false,
          );
        } else {
          _showError(responseData['message']);
        }
      } catch (e) {
        print('Error parsing response: $e');
        _showError('Failed to parse response. Please try again.');
      }
    } else {
      _showError('Failed to login. Please try again.');
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
          title: "Personal Data",
          bgColor: LColors.primary,
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
                            child: InputTextWidget(
                          labelText: 'Full Name According to KTP',
                          hintText: 'Andi Setia Budi',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _namaLengkapRegisSementaraController,
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          labelText: 'Place of birth',
                          hintText: 'Bandung',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _tempatLahirRegisSementaraController,
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputDateWidget(
                          controller: _tanggalLahirRegisSementaraController,
                          labelText: 'Date of birth',
                          hintText:
                              _tanggalLahirRegisSementaraController.text == ''
                                  ? '17 Januari 2024'
                                  : _tanggalLahirRegisSementaraController.text,
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (date) {
                            // Tindakan yang diambil ketika tanggal berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          labelText: 'Whatsapp Number',
                          hintText: '+6285720075826',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _whatsappRegisSementaraController,
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child:
                              //   InputTextWidget(
                              // controller: _provinsiTinggalRegisSementaraController,
                              // labelText: 'Provinsi Domisili',
                              // hintText: 'Jawa Timur',
                              // borderColor:
                              //     Colors.blue, // Opsional: mengatur warna border
                              // onChanged: (text) {
                              //   // Tindakan yang diambil ketika nilai input berubah
                              // },
                              // )
                              Container(
                            padding: EdgeInsets.fromLTRB(12, 4, 4, 4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: LColors.borderInput),
                                borderRadius: BorderRadius.circular(4)),
                            child: DropdownButton<String>(
                              hint: Text('Province Residence'),
                              value: selectedProvince,
                              isExpanded: true,
                              items: provinces.map((Province province) {
                                return DropdownMenuItem<String>(
                                  value: province.id,
                                  child: Text(province.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedProvince = newValue;
                                  _provinsiTinggalRegisSementaraController
                                          .text =
                                      provinces
                                          .firstWhere((province) =>
                                              province.id == newValue)
                                          .name;
                                  selectedCity = null;
                                  cities = [];
                                });
                                fetchCities(newValue!).then((data) {
                                  setState(() {
                                    cities = data;
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child:
                              //   InputTextWidget(
                              // controller: _kotaTinggalRegisSementaraController,
                              // labelText: 'Kota Domisili',
                              // hintText: 'Surabaya',
                              // borderColor:
                              //     Colors.blue, // Opsional: mengatur warna border
                              // onChanged: (text) {
                              // Tindakan yang diambil ketika nilai input berubah
                              // },
                              // )
                              Container(
                            padding: EdgeInsets.fromLTRB(12, 4, 4, 4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: LColors.borderInput),
                                borderRadius: BorderRadius.circular(4)),
                            child: DropdownButton<String>(
                              hint: Text('City Residence'),
                              value: selectedCity,
                              isExpanded: true,
                              items: cities.map((City city) {
                                return DropdownMenuItem<String>(
                                  value: city.id,
                                  child: Text(city.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCity = newValue;
                                  _kotaTinggalRegisSementaraController.text =
                                      cities
                                          .firstWhere(
                                              (city) => city.id == newValue)
                                          .name;
                                  ;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          labelText: 'Facebook',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _facebookRegisSementaraController,
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          labelText: 'Instagram',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _instagramRegisSementaraController,
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          labelText: 'LinkedIn',
                          hintText: '@username',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                          controller: _linkedinRegisSementaraController,
                        )),
                      ],
                    ),
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
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: send,
                            text: 'SAVE',
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
