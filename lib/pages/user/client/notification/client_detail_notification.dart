import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:letter_a/controller/config.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';

class ClientNotificationDetailPage extends StatefulWidget {
  final String token;
  final int notificationId;

  ClientNotificationDetailPage(
      {required this.token, required this.notificationId});

  @override
  _ClientNotificationDetailPageState createState() =>
      _ClientNotificationDetailPageState();
}

class _ClientNotificationDetailPageState
    extends State<ClientNotificationDetailPage> {
  Map<String, dynamic>? notificationDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNotificationDetails();
  }

  Future<void> fetchNotificationDetails() async {
    final response = await http.get(
      Uri.parse(
          '$server/api/v1/api_detail_notification.php?notification_id=${widget.notificationId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          notificationDetails = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data['message'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load notification details.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LAppBar(
        title: "Details",
        bgColor: LColors.primary,
        // useFor: 'announcementC',
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
        actions: [],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'User ID: ${notificationDetails!['UserID']}',
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${notificationDetails!['Tanggal']}',
                                style: LText.description(),
                              ),
                            ),
                            Text(
                              '${notificationDetails!['Pukul']}',
                              style: LText.description(),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        notificationDetails!['Thumbnail'] != null
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        '$server/api/v1/${notificationDetails!['Thumbnail']}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),

                        SizedBox(height: 16),
                        Text(
                          '${notificationDetails!['Judul']}',
                          style: LText.H3(),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${notificationDetails!['Message']}',
                                style: LText.readPage(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
