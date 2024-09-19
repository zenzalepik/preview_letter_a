import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/controller/user_profile_controller.dart';
import 'package:letter_a/models/contract_model.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/client/hire/hired_page.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/review/sent_review_alert.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:http/http.dart' as http;

class ReviewVAPage extends StatefulWidget {
  final Contract contract;
  final String? aplicationId;
  final String? vaId;
  final String? vaName;
  final String? VAPhotoProfile;
  ReviewVAPage({
    required this.aplicationId,
    required this.vaId,
    required this.vaName,
    required this.contract,
    required this.VAPhotoProfile,
  });

  @override
  State<ReviewVAPage> createState() => _ReviewVAPageState();
}

class _ReviewVAPageState extends State<ReviewVAPage> {
  //int _selectedValue = 1;

  final TextEditingController _applicationIdController =
      TextEditingController();
  final TextEditingController _ratingController =
      TextEditingController(text: '0.0');
  double _rating = 0.0;
  //bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> giveRatingForVA() async {
    setState(() {
      _applicationIdController.text = '${widget.aplicationId}';
    });
    final String apiUrl =
        "$server/api/v1/ratings/api_give_rating_for_va.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "rating": _ratingController.text,
      },
    );

    final data = json.decode(response.body);

    if (data['success']) {
      print('>>>>Here');
      await fetchAverageRating(int.parse('${widget.vaId}'));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       backgroundColor: LColors.red,
      //       content: Text("Thank you for your rating to our VA",
      //           style: TextStyle(color: LColors.white))),
      // );
      _alertHire(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.red,
            content: Text("Error, ${data['message']}",
                style: TextStyle(color: LColors.white))),
      );
    }
  }

  /// Mengambil rata-rata rating berdasarkan UserID dari API.
  Future<Map<String, dynamic>> fetchAverageRating(int userId) async {
    final String apiUrl =
        '$server/api/v1/ratings/api_average_rating_va.php'; // Ganti dengan URL API Anda

    try {
      // Membuat permintaan GET ke API
      final response = await http.get(Uri.parse('$apiUrl?userid=$userId'));

      // Memeriksa status kode dari respons
      if (response.statusCode == 200) {
        // Mengurai respons JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Memeriksa apakah respons berhasil
        if (data['success']) {
          print('sukses give rating ${widget.vaId}');
          return {
            'average_rating': data['average_rating'],
            'data': data['data'],
          };
        } else {
          throw Exception('Gagal mendapatkan rating: ${data['message']}');
        }
      } else {
        throw Exception('Gagal menghubungi server: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani kesalahan
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  void _alertHire(BuildContext context) async {
    // Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SentReviewAlert();
      },
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
        // appBar: LAppBar(
        //   title: "Review VA",
        //   bgColor: LColors.primary,
        //   actions: <Widget>[],
        //   leading: GestureDetector(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: SvgPicture.asset(
        //       'assets/icons/icon_back.svg',
        //       width: 200, // atur lebar gambar sesuai kebutuhan Anda
        //       height: 200, // atur tinggi gambar sesuai kebutuhan Anda
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: LColors.white),
                  child:
                      Text("Give an assessment to your VA", style: LText.H3())),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.network(
                                          '$server/api/v1/${widget.VAPhotoProfile}',
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover))),
                              SizedBox(width: 12),
                              Text('${widget.vaName}', style: LText.subtitle()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                          dashPattern: [8, 4], // panjang garis dan spasi

                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color.fromARGB(55, 0, 152, 15)),
                              child: Column(
                                children: [
                                  SizedBox(height: 24),
                                  RatingBar.builder(
                                    initialRating: _rating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                        _ratingController.text = '$_rating';
                                      });
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    '${double.parse(_ratingController.text)}',
                                    style: LText.ratingNumber(),
                                  )
                                ],
                              )),
                        )),
                      ],
                    ),
                    GapCInput(),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: () {
                              giveRatingForVA();
                            },
                            text: 'SEND REVIEW',
                          ),
                        ),
                      ],
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
