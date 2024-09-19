import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/city_and_province_model.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_portfolio_page.dart';
import 'package:letter_a/pages/user/va/auth/free_sign_up_social_media_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FreeSignUpPersonalDataPage extends StatefulWidget {
  const FreeSignUpPersonalDataPage({super.key});

  @override
  State<FreeSignUpPersonalDataPage> createState() =>
      _FreeSignUpPersonalDataPageState();
}

class _FreeSignUpPersonalDataPageState
    extends State<FreeSignUpPersonalDataPage> {
  final TextEditingController _namaLengkapRegisSementaraController =
      TextEditingController();
  final TextEditingController _tempatLahirRegisSementaraController =
      TextEditingController();
  final TextEditingController _tanggalLahirRegisSementaraController =
      TextEditingController();
  final TextEditingController _whatsappRegisSementaraController =
      TextEditingController();
  final TextEditingController _ijazahRegisSementaraController =
      TextEditingController();
  final TextEditingController _kotaTinggalRegisSementaraController =
      TextEditingController();
  final TextEditingController _provinsiTinggalRegisSementaraController =
      TextEditingController();

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
    prefs.setString('ijazahRegisSementara', '');
  }

  Future<void> regisSementara2() async {
    final prefs = await SharedPreferences.getInstance();
    String namaLengkap = _namaLengkapRegisSementaraController.text;
    String tempatLahir = _tempatLahirRegisSementaraController.text;
    String tanggalLahir = _tanggalLahirRegisSementaraController.text;
    String whatsapp = _whatsappRegisSementaraController.text;
    String ijazah = _ijazahRegisSementaraController.text;
    String kotaTinggal = _kotaTinggalRegisSementaraController.text;
    String provinsiTinggal = _provinsiTinggalRegisSementaraController.text;

    setState(() {
      prefs.setString('namaLengkapRegisSementara', namaLengkap);
      prefs.setString('userId', namaLengkap);
      prefs.setString('tempatLahirRegisSementara', tempatLahir);
      prefs.setString('tanggalLahirRegisSementara', tanggalLahir);
      prefs.setString('whatsappRegisSementara', whatsapp);
      prefs.setString('ijazahRegisSementara', ijazah);
      prefs.setString('kotaTinggalRegisSementara', kotaTinggal);
      prefs.setString('provinsiTinggalRegisSementara', provinsiTinggal);
      // print('${prefs.getString('passwordRegisSementara') ?? ''}');
      // _passwordRegisSementaraController.text =
      // prefs.getString('passwordRegisSementara') ?? '';
    });
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
        // _ijazahRegisSementaraController.text.isEmpty ||
        // _ijazahRegisSementaraController.text.isEmpty ||
        _ijazahRegisSementaraController.text.isEmpty) {
      _showError('Please fill in all the data correctly.');
      return;
    } else {
      await regisSementara2();

      print('${prefs.getString('namaLengkapRegisSementara') ?? ''}');
      print('${prefs.getString('tempatLahirRegisSementara') ?? ''}');
      print('${prefs.getString('tanggalLahirRegisSementara') ?? ''}');
      print('${prefs.getString('whatsappRegisSementara') ?? ''}');
      print('${prefs.getString('ijazahRegisSementara') ?? ''}');
      print('${prefs.getString('kotaTinggalRegisSementara') ?? ''}');
      print('${prefs.getString('provinsiTinggalRegisSementara') ?? ''}');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreeSignUpSocialMediaPage()),
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
          title: "Personal Data",
          bgColor: LColors.black,
          actions: <Widget>[],
          leading: GestureDetector(
            onTap: () {
              clearData();
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
                          controller: _namaLengkapRegisSementaraController,
                          labelText: 'Full Name According to KTP',
                          hintText: 'Andi Setia Budi',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          controller: _tempatLahirRegisSementaraController,
                          labelText: 'Place of birth',
                          hintText: 'Bandung',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
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
                          controller: _whatsappRegisSementaraController,
                          labelText: 'Whatsapp Number',
                          hintText: '+6285720075826',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
                        )),
                      ],
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                            child: InputTextWidget(
                          controller: _ijazahRegisSementaraController,
                          labelText: 'Ijazah Terakhir',
                          hintText: 'S1 Sistem Informasi',
                          borderColor:
                              Colors.blue, // Opsional: mengatur warna border
                          onChanged: (text) {
                            // Tindakan yang diambil ketika nilai input berubah
                          },
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
                    /* GapCInput(),
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
                  
                  */
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: _submitForm,
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
