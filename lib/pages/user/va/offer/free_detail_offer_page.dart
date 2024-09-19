import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/backup/sudah/applications_list.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/application_model.dart';
import 'package:letter_a/pages/user/va/free_main_page.dart';
import 'package:letter_a/pages/user/va/message/free_list_message_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:http/http.dart' as http;

class FreeOfferDetailPage extends StatefulWidget {
  final Application application;

  FreeOfferDetailPage({required this.application});

  @override
  State<FreeOfferDetailPage> createState() => _FreeOfferDetailPageState();
}

class _FreeOfferDetailPageState extends State<FreeOfferDetailPage> {
  final TextEditingController _applicationIdController =
      TextEditingController();
  final TextEditingController _vaidController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _tanggalApproveController =
      TextEditingController();
  final TextEditingController _tanggalSelesaiController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String formatRupiah(String amount) {
      // Menghapus karakter non-digit dan mengonversi ke integer
      final cleanedAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
      final int value = int.parse(cleanedAmount);
      final formatter = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(value);
    }

    String formatTanggal(String tanggal) {
      DateTime dateTime = DateTime.parse(tanggal);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    bool isValidNumberWithDot(String value) {
      final regex = RegExp(r'^[0-9.]+$');
      return regex.hasMatch(value);
    }

    Future<void> inisiasi() async {
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(now);
      setState(() {
        _applicationIdController.text = widget.application.applicationID;
        _vaidController.text = '0';
        _userIdController.text = '${widget.application.userId}';
        _clientIdController.text = '${widget.application.clientId}';
        _tanggalApproveController.text = '$formattedDate';
        _tanggalSelesaiController.text = '2000-02-02';
        _statusController.text = 'running';
        _ratingController.text = '0.0';
      });
    }

    Future<void> _createContract() async {
      await inisiasi();

      print(
          '_applicationIdController.text ${widget.application.applicationID}');
      print('_userIdController.text ${_userIdController.text}');
      print('_clientIdController.text ${_clientIdController.text}');
      print('_tanggalApproveController.text ${_tanggalApproveController.text}');
      print('_statusController.text ${_statusController.text}');
      final url =
          '$server/api/v1/contracts/create_contract.php'; // Ganti dengan URL API Anda

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'application_id': int.parse(_applicationIdController.text),
          'Vaid': int.parse(_vaidController.text),
          'UserID': int.parse(_userIdController.text),
          'ClientID': int.parse(_clientIdController.text),
          'TanggalApprove': _tanggalApproveController.text,
          'TanggalSelesai': _tanggalSelesaiController.text,
          'Status': _statusController.text,
          'Rating': double.parse(_ratingController.text),
        }),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        print('sini');
        final data = jsonDecode(response.body);
        if (data['success'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: LColors.primary,
                content: Text('Contract created successfully!')),
          );

          // Tunggu 3 detik sebelum pindah ke halaman Home
          await Future.delayed(Duration(seconds: 3));

          // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => FreeListMessagePage(index: '2')),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to create contract: ${data['error']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create contract')),
        );
      }
    }

    Future<void> _rejectApplication() async {
      // Inisialisasi data yang dibutuhkan (misalnya mengambil token atau data lain jika diperlukan)
      await inisiasi();

      // Cetak data untuk memeriksa apakah data controller sudah benar
      print('Application ID: ${widget.application.applicationID}');
      print('User ID: ${_userIdController.text}');
      print('Client ID: ${_clientIdController.text}');
      print('Status: ${_statusController.text}');

      // URL API untuk reject application
      final url = '$server/api/v1/applications/api_reject_application.php';

      // Lakukan request POST ke API
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'application_id': int.parse(_applicationIdController.text),
          'UserID': int.parse(_userIdController.text),
          'ClientID': int.parse(_clientIdController.text),
          'Status':
              'rejected', // Karena ini request reject, statusnya di-set 'rejected'
        }),
      );

      // Cetak response dari API
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] != null) {
          // Jika reject berhasil, tampilkan pesan dan tunggu 3 detik sebelum ke halaman Home
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: LColors.red,
              content: Text('Application rejected successfully!'),
            ),
          );

          // Tunggu 3 detik
          await Future.delayed(Duration(seconds: 3));

          // Arahkan ke halaman Home atau halaman lain yang sesuai
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => FreeListMessagePage(index: '0')),
            (route) => false,
          );
        } else {
          // Jika ada kesalahan dari API
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to reject application: ${data['error']}')),
          );
        }
      } else {
        // Jika request gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject application')),
        );
      }
    }

    return Scaffold(
      appBar: LAppBar(
        title: "Offer Detail",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text('${widget.application.title}',
                          style: LText.H3())),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: isValidNumberWithDot(widget.application.ratePrice)
                        ? Text(
                            widget.application.ratePrice == '' ||
                                    widget.application.ratePrice == 'null' ||
                                    widget.application.ratePrice == null
                                ? ''
                                : '${formatRupiah(widget.application.ratePrice)}',
                            style: LText.H5(color: LColors.primary))
                        : Text(widget.application.ratePrice,
                            style: LText.H5(color: LColors.primary)),
                  ),
                  Visibility(
                    visible: widget.application.status == '' ||
                            widget.application.status == null
                        ? false
                        : true,
                    child: Positioned(
                        right: 0,
                        child: widget.application.status == 'pending'
                            ? SvgPicture.asset(
                                'assets/icons/img_label_application_pending.svg')
                            : widget.application.status == 'accepted'
                                ? SvgPicture.asset(
                                    'assets/icons/img_label_application_accepted.svg')
                                : widget.application.status == 'done'
                                    ? SvgPicture.asset(
                                        'assets/icons/img_label_application_done.svg')
                                    : widget.application.status == 'rejected'
                                        ? SvgPicture.asset(
                                            'assets/icons/img_label_application_rejected.svg')
                                        : SvgPicture.asset(
                                            'assets/icons/img_label_working.svg')),
                  )
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              // SizedBox(height: 8),
              // SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 124,
                          child:
                              Text('Tanggal Mulai:', style: LText.labelData()),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 16),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                                '${formatTanggal(widget.application.tanggalMulai)}',
                                style: LText.description()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 124,
                          child: Text('Tanggal Selesai:',
                              style: LText.labelData()),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 16),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                                '${formatTanggal(widget.application.tanggalSelesai)}',
                                style: LText.description()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 8),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              SizedBox(height: 12),
              Text('Project Description:', style: LText.labelData()),
              SizedBox(height: 4),
              Text('''${widget.application.description}''',
                  style: LText.descriptionLong()),
              SizedBox(height: 8),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              Text('Proof of Payment', style: LText.labelData()),
              SizedBox(height: 4),
              widget.application.proof.isNotEmpty
                  ? InteractiveViewer(
                      panEnabled: true, // Aktifkan penggeseran
                      minScale: 1.0, // Skala minimal
                      maxScale: 4.0, // Skala maksimal, bisa disesuaikan
                      child: GestureDetector(
                        onTap: () {
                          _showImageDialog(context,
                              'https://letter-a.co.id/api/v1/uploads/proofs/${widget.application.proof}');
                        },
                        child: Image.network(
                          'https://letter-a.co.id/api/v1/uploads/proofs/${widget.application.proof}',
                        ),
                      ),
                    )
                  : Text('No proof available'),
              SizedBox(
                height: 12,
              ),
              Opacity(
                opacity: 0.72,
                child: Row(
                  children: [
                    Text(
                      'Offer made on: ',
                    ),
                    Expanded(child: Divider(height: 1, color: LColors.line)),
                    Text(
                      ' ${formatTanggal(widget.application.tanggalPengajuan)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: LColors.white, boxShadow: [
          BoxShadow(
            blurRadius: 32,
            color: Colors.grey,
          )
        ]),
        child: widget.application.status == 'accepted'
            ? Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text('You are working here',
                        textAlign: TextAlign.center,
                        style: LText.labelData(color: LColors.primary)),
                    decoration: BoxDecoration(
                        color: LColors.transparentPrimary,
                        borderRadius: BorderRadius.circular(16)),
                  )),
                ],
              )
            : widget.application.status == 'done'
                ? Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text('This project has been DONE',
                            textAlign: TextAlign.center,
                            style: LText.H5(color: LColors.primary)),
                        decoration: BoxDecoration(
                            color: LColors.black,
                            border:
                                Border.all(width: 4, color: LColors.primary),
                            borderRadius: BorderRadius.circular(16)),
                      )),
                    ],
                  )
                : widget.application.status == 'pending'
                    ? Row(
                        children: [
                          Expanded(
                            child: ButtonSmall(
                              onPressed: _rejectApplication,
                              color: LColors.red,
                              colorText: LColors.white,
                              text: 'Reject',
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ButtonSmall(
                              onPressed: _createContract,
                              color: LColors.primary,
                              colorText: LColors.white,
                              text: 'Accept',
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
