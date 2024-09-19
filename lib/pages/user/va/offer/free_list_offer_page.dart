import 'package:flutter/material.dart';
import 'package:letter_a/backup/sudah/application_detail_page.dart';
import 'package:letter_a/backup/sudah/applications_list.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/application_model.dart';
import 'package:letter_a/pages/user/client/offer/detail_offer_page.dart';
import 'package:letter_a/pages/user/va/offer/free_detail_offer_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/offer_card_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FreeListOfferPage extends StatefulWidget {
  // final String ratePrice;
  // final String tanggalPengajuan;
  // final String title;
  const FreeListOfferPage({
    super.key,
    // required this.ratePrice,
    // required this.tanggalPengajuan,
    // required this.title
  });

  @override
  State<FreeListOfferPage> createState() => _FreeListOfferPageState();
}

class _FreeListOfferPageState extends State<FreeListOfferPage> {
  late Future<List<Application>> _applications;
  bool isLoading = true;
  String vaId = '';

  @override
  void initState() {
    super.initState();
    _applications = fetchApplications();
  }

  Future<void> getVaId() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    setState(() {
      vaId = userId;
    });
    print('User ID >>> $vaId');
  }

  Future<List<Application>> fetchApplications() async {
    await getVaId();

    final response = await http.get(Uri.parse(
        '$server/api/v1/applications/api_get_applications_for_va.php?UserID=$vaId'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody); // Debug output

      List<dynamic> data = responseBody['data'];

      setState(() {
        isLoading = false;
      });
      return data.map((json) => Application.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Column(children: [
                    FutureBuilder<List<Application>>(
                      future: _applications,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('Tidak ada aplikasi ditemukan'));
                        } else {
                          List<Application> applications = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              return ItemOfferWidget(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FreeOfferDetailPage(
                                        application: applications[index],
                                      ),
                                    ),
                                  );
                                },
                                status: '${applications[index].status}',
                                thumbnail: '${applications[index].title}',
                                title: '${applications[index].title}',
                                ratePrice: '${applications[index].ratePrice}',
                                tanggalPengajuan:
                                    '${applications[index].tanggalPengajuan}',
                                read: true,
                              );
                            },
                          );
                        }
                      },
                    )
                  ])),
        SizedBox(height: 40)
      ],
    ));
  }
}
