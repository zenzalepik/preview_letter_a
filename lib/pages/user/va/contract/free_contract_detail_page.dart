import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/controller/config.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/user_profile_controller.dart';
import 'package:letter_a/main.dart';
import 'package:letter_a/models/contract_model.dart';
import 'package:letter_a/pages/user/va/message/free_list_message_page.dart';
import 'package:letter_a/pages/user/va/review/free_review_client_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeApiGetAplicationDetailService {
  final String baseUrl =
      '$server/api/v1/applications/api_view_application_by_id.php'; // Ganti dengan URL server Anda

  Future<Application?> fetchApplication(int applicationID) async {
    final response =
        await http.get(Uri.parse('$baseUrl?ApplicationID=$applicationID'));

    if (response.statusCode == 200) {
      print('Benar');
      final data = jsonDecode(response.body) as List;
      if (data.isNotEmpty) {
        return Application.fromJson(data[0]);
      }
    }
    return null;
  }
}

class FreeContractDetailScreen extends StatefulWidget {
  final Contract contract;

  FreeContractDetailScreen({required this.contract});

  @override
  State<FreeContractDetailScreen> createState() =>
      _FreeContractDetailScreenState();
}

class _FreeContractDetailScreenState extends State<FreeContractDetailScreen> {
  late Future<Application?> _application;
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  bool hasError = false;
  final UserService userService = UserService('$server'); // Sesuaikan server
  String VAName = '';
  String ClientId = '';
  String ClientName = '';
  final TextEditingController _linkFileController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  String ClientPhotoProfile = '';

  @override
  void initState() {
    super.initState();
    _loadUserVAProfile();
    _loadUserClientProfile();
    print('widget.contract.application_id ${widget.contract.application_id}');
    _application = FreeApiGetAplicationDetailService().fetchApplication(
        int.parse(widget.contract
            .application_id)); // Ganti dengan ApplicationID yang diinginkan
    // print('${widget.contract.RatingClient}');
  }

  bool isValidNumberWithDot(String value) {
    final regex = RegExp(r'^[0-9.]+$');
    return regex.hasMatch(value);
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatTanggal(String tanggal) {
    // Parsing string ke DateTime
    DateTime dateTime = DateTime.parse(tanggal);
    // Memformat DateTime ke string dengan format yang diinginkan
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  String formatRupiah(String amount) {
    // Menghapus karakter non-digit dan mengonversi ke integer
    final cleanedAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final int value = int.parse(cleanedAmount);
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> _loadUserVAProfile() async {
    try {
      final profile =
          await userService.fetchUserProfile(widget.contract.UserID);
      if (profile != null) {
        setState(() {
          userProfile = profile;
          VAName = '${userProfile!['fullName'] ?? 'N/A'}';
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserClientProfile() async {
    try {
      final profile =
          await userService.fetchUserProfile(widget.contract.ClientID);
      if (profile != null) {
        setState(() {
          userProfile = profile;
          ClientName = '${userProfile!['fullName'] ?? 'N/A'}';
          ClientId = '${userProfile!['id'] ?? 'N/A'}';
          ClientPhotoProfile = '${userProfile!['profileImage'] ?? 'N/A'}';
          print('>>>>>>>>>>>>>>>>>>>$ClientPhotoProfile');
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> sendLinkFile() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_send_file_done_contract.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "tanggal_selesai": '2000-02-02',
        "status": 'review',
        "link_file": _linkFileController.text,
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text("Data berhasil diperbarui")),
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
        SnackBar(content: Text("Gagal memperbarui data: ${data['message']}")),
      );
    }
  }

  // Future<void> setAlasan() async {
  //   setState(() {
  //     _alasanController.text;
  //   });
  // }

  Future<void> pauseProject() async {
    final String apiUrl = "$server/api/v1/contracts/api_pause_contract.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'pending',
        "approval_client": '',
        "alasan": _alasanController.text,
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.yellow,
            content: Text("Your request has been sent",
                style: TextStyle(color: LColors.black))),
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
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> rejectProject() async {
    final String apiUrl = "$server/api/v1/contracts/api_reject_contract.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'reject',
        "approval_client": '',
        "alasan": _alasanController.text,
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.red,
            content: Text("Your request has been sent",
                style: TextStyle(color: LColors.white))),
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
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> resumeProject() async {
    final String apiUrl = "$server/api/v1/contracts/api_resume_contract.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'running',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text("Your request has been sent",
                style: TextStyle(color: LColors.white))),
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
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

// Fungsi untuk membuka link di browser
  void _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LAppBar(
        title: "Contract Details",
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
                  Text('Contract ID:', style: LText.labelData()),
                  Expanded(
                    child: Text(' L3TTER${widget.contract.application_id}',
                        style: LText.labelData(color: LColors.primary)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: widget.contract.Status == 'running'
                            ? LColors.blue
                            : widget.contract.Status == 'pending'
                                ? LColors.yellow
                                : widget.contract.Status == 'done'
                                    ? LColors.primary
                                    : widget.contract.Status == 'reject'
                                        ? LColors.red
                                        : widget.contract.Status == 'failded'
                                            ? LColors.failed
                                            : widget.contract.Status == 'review'
                                                ? LColors.transparentPrimary
                                                : LColors.black),
                    child: Text(
                      (widget.contract.ApprovalClient != 'approved') &&
                              widget.contract.Status == 'reject'
                          ? 'Request Reject'
                          : (widget.contract.ApprovalClient == 'approved') &&
                                  widget.contract.Status == 'reject'
                              ? 'Rejected'
                              : (widget.contract.ApprovalClient !=
                                          'approved') &&
                                      widget.contract.Status == 'pending'
                                  ? 'Request to Pause'
                                  : (widget.contract.ApprovalClient ==
                                              'approved') &&
                                          widget.contract.Status == 'pending'
                                      ? 'Pending'
                                      : '${capitalizeFirstLetter(widget.contract.Status)}',
                      style: LText.labelDataTahun(
                        // weight: widget.read == false || widget.read == null ?
                        weight: FontWeight.w700,
                        color: widget.contract.Status == 'pending'
                            ? LColors.black
                            : widget.contract.Status == 'review'
                                ? LColors.primary
                                : widget.contract.Status == 'pending'
                                    ? LColors.black
                                    : LColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              /*Text(
                'Vaid: ${widget.contract.Vaid}',
              ),
              SizedBox(height: 8),
              */
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              FutureBuilder<Application?>(
                future: _application,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final application = snapshot.data!;
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Title Ptoject:', style: LText.labelData()),
                        Row(
                          children: [
                            Expanded(
                                child: Text('${application.title}',
                                    style: LText.H3())),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(height: 1, color: LColors.line),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rate Project',
                                      style: LText.labelData()),
                                  Row(children: [
                                    // Text('Cost:', style: LText.H5()),
                                    Expanded(
                                      child: isValidNumberWithDot(application
                                              .ratePrice)
                                          ? Text(
                                              application.ratePrice == '' ||
                                                      application.ratePrice ==
                                                          'null' ||
                                                      application.ratePrice ==
                                                          null
                                                  ? ''
                                                  : '${formatRupiah(application.ratePrice)}',
                                              style: LText.H5(
                                                  color: LColors.primary))
                                          : Text('${application.ratePrice}',
                                              style: LText.H5(
                                                  color: LColors.primary)),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            widget.contract.Status == 'done' &&
                                    (widget.contract.Rating != '0.00' &&
                                        widget.contract.RatingClient != '0')
                                ? Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /*Text(
                                            'Rating: ',
                                          ),*/
                                          Row(
                                            children: [
                                              Icon(Icons.star,
                                                  color: LColors.yellow),
                                              Text('${widget.contract.Rating}',
                                                  style: LText.subtitle()),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(height: 1, color: LColors.line),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 124,
                                    child: Text('VA Name:',
                                        style: LText.labelData()),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outlined, size: 16),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text('$VAName',
                                          //'$VAName${widget.contract.UserID}',
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
                                    child: Text('Client ID:',
                                        style: LText.labelData()),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outlined, size: 16),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text('$ClientName',
                                          //'$ClientName${widget.contract.ClientID}',
                                          style: LText.description()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(height: 1, color: LColors.line),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 124,
                                    child: Text('Start Date:',
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
                                          '${formatTanggal(application.tanggalMulai)}',
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
                                    child: Text('End Date:',
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
                                          '${formatTanggal(application.tanggalSelesai)}',
                                          style: LText.description()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(height: 1, color: LColors.line),
                        SizedBox(height: 12),
                        Text('Project Description:', style: LText.labelData()),
                        SizedBox(height: 4),
                        Text('''${application.description}''',
                            style: LText.descriptionLong()),
                        SizedBox(height: 12),
                        Divider(height: 1, color: LColors.line),
                        SizedBox(height: 12),
                        Text('Proof of Payment', style: LText.labelData()),
                        SizedBox(height: 4),
                        application.proof.isNotEmpty
                            ? InteractiveViewer(
                                panEnabled: true, // Aktifkan penggeseran
                                minScale: 1.0, // Skala minimal
                                maxScale:
                                    4.0, // Skala maksimal, bisa disesuaikan
                                child: GestureDetector(
                                  onTap: () {
                                    _showImageDialog(context,
                                        'https://letter-a.co.id/api/v1/uploads/proofs/${application.proof}');
                                  },
                                  child: Image.network(
                                    'https://letter-a.co.id/api/v1/uploads/proofs/${application.proof}',
                                  ),
                                ),
                              )
                            : Text('No proof available'),
                      ],
                    );
                  } else {
                    return Center(child: Text('No data found'));
                  }
                },
              ),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              (widget.contract.LinkFile != '' &&
                          widget.contract.LinkFile != null &&
                          widget.contract.LinkFile != 'null') &&
                      (widget.contract.Status == 'review' ||
                          widget.contract.Status == 'done')
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                Text('Job File Link (last update):',
                                    style: LText.labelData()),
                                SizedBox(height: 4),
                                Text('''${widget.contract.LinkFile}''',
                                    style: LText.descriptionLong()),
                                ButtonSmall(
                                  text: 'Open file link',
                                  color: LColors.primary,
                                  colorText: LColors.white,
                                  onPressed: () {
                                    _launchURL('${widget.contract.LinkFile}');
                                  },
                                ),
                                SizedBox(height: 40),
                                SizedBox(height: 12),
                                Divider(height: 1, color: LColors.line),
                                SizedBox(height: 12),
                              ]),
                        )
                      ],
                    )
                  : SizedBox(),
              Opacity(
                opacity: 0.56,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 124,
                            child: Text('Project Approve:',
                                style: LText.labelData()),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              /*Icon(Icons.date_range_outlined, size: 16),
                              SizedBox(
                                width: 4,
                              ),*/
                              Text(
                                  '${formatTanggal(widget.contract.TanggalApprove)}',
                                  style: LText.description()),
                            ],
                          ),
                        ],
                      ),
                    ), /*
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 124,
                            child:
                                Text('Project end:', style: LText.labelData()),
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
                                  '${formatTanggal(widget.contract.TanggalSelesai)}',
                                  style: LText.description()),
                            ],
                          ),
                        ],
                      ),
                    ),*/
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
        child: (widget.contract.ApprovalClient == 'approved') &&
                widget.contract.Status == 'reject'
            ? Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text('This project has been rejected',
                        textAlign: TextAlign.center,
                        style: LText.labelData(color: LColors.red)),
                    decoration: BoxDecoration(
                        color: LColors.red.withOpacity(0.24),
                        borderRadius: BorderRadius.circular(16)),
                  )),
                ],
              )
            : (widget.contract.ApprovalClient != 'approved') &&
                    widget.contract.Status == 'reject'
                ? Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Waiting for client approval',
                            textAlign: TextAlign.center,
                            style: LText.labelData(color: LColors.red)),
                        decoration: BoxDecoration(
                            color: LColors.red.withOpacity(0.24),
                            borderRadius: BorderRadius.circular(16)),
                      )),
                    ],
                  )
                : widget.contract.Status == 'running'
                    ? Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: ButtonSmall(
                              onPressed: () {
                                _pauseProjectDialog(context);
                              },
                              color: LColors.yellow,
                              colorText: LColors.secondary,
                              text: 'Pause',
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ButtonSmall(
                              onPressed: () {
                                _showLinkFileFormDialog(context);
                              },
                              color: LColors.primary,
                              colorText: LColors.white,
                              text: 'Done',
                            ),
                          ),
                        ],
                      )
                    : widget.contract.Status == 'done'
                        ? Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height:
                                    widget.contract.RatingClient == '0.00' ||
                                            widget.contract.RatingClient ==
                                                '0' ||
                                            widget.contract.RatingClient ==
                                                '' ||
                                            widget.contract.RatingClient ==
                                                'null' ||
                                            widget.contract.RatingClient == null
                                        ? 140
                                        : 80,
                                child: Column(
                                  children: [
                                    widget.contract.RatingClient == '0.00' ||
                                            widget.contract.RatingClient ==
                                                '0' ||
                                            widget.contract.RatingClient ==
                                                '' ||
                                            widget.contract.RatingClient ==
                                                'null' ||
                                            widget.contract.RatingClient == null
                                        ? GestureDetector(
                                            onTap: () {
                                              // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReviewClientPage(
                                                          aplicationId:
                                                              '${widget.contract.application_id}',
                                                          clientName:
                                                              '$ClientName',
                                                          contract:
                                                              widget.contract,
                                                          ClientPhotoProfile:
                                                              '$ClientPhotoProfile',
                                                          clientId: '$ClientId',
                                                        )),
                                                // MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
                                                (route) => false,
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .star_border_outlined,
                                                            color:
                                                                LColors.white),
                                                        SizedBox(width: 4),
                                                        Text(
                                                            'Give Rating For Client',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: LText.H5(
                                                                color: LColors
                                                                    .white)),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: LColors.primary,
                                                        // border: Border.all(
                                                        //     width: 4,
                                                        //     color: LColors
                                                        //         .primary),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 12,
                                                              color: LColors
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.44),
                                                              offset: Offset(
                                                                  0.0, 12.0))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    widget.contract.RatingClient == '0.00' ||
                                            widget.contract.RatingClient ==
                                                '0' ||
                                            widget.contract.RatingClient ==
                                                '' ||
                                            widget.contract.RatingClient ==
                                                'null' ||
                                            widget.contract.RatingClient == null
                                        ? SizedBox(
                                            height: 16,
                                          )
                                        : SizedBox(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                                'This project has been DONE',
                                                textAlign: TextAlign.center,
                                                style: LText.H5(
                                                    color: LColors.primary)),
                                            decoration: BoxDecoration(
                                                color: LColors.black,
                                                border: Border.all(
                                                    width: 4,
                                                    color: LColors.primary),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          )
                        : widget.contract.Status == 'review'
                            ? Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Reviewing Your Work',
                                        textAlign: TextAlign.center,
                                        style: LText.labelData(
                                            color: LColors.primary)),
                                    decoration: BoxDecoration(
                                        color: LColors.transparentPrimary,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  )),
                                ],
                              )
                            : (widget.contract.ApprovalClient == 'approved') &&
                                    widget.contract.Status == 'pending'
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ButtonSmall(
                                          onPressed: () {
                                            _rejectProjectDialog(context);
                                            // Navigator.pop(context);
                                          },
                                          color: LColors.red,
                                          colorText: LColors.white,
                                          text: 'Reject Project',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: ButtonSmall(
                                          onPressed: () {
                                            _resumeProjectDialog(context);
                                          },
                                          color: LColors.primary,
                                          colorText: LColors.white,
                                          text: 'Resume Project',
                                        ),
                                      ),
                                    ],
                                  )
                                : (widget.contract.ApprovalClient !=
                                            'approved') &&
                                        widget.contract.Status == 'pending'
                                    ? Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Text(
                                                'Waiting for client approval',
                                                textAlign: TextAlign.center,
                                                style: LText.labelData(
                                                    color: LColors.yellow)),
                                            decoration: BoxDecoration(
                                                color: LColors.yellow
                                                    .withOpacity(0.24),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                          )),
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

  void _resumeProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Let's go back to the project!",
              style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you ready to continue the project?'),
                SizedBox(height: 20),
                Row(children: [
                  SizedBox(
                    width: 120,
                    child: ButtonSmall(
                      text: 'Cancel',
                      color: LColors.transparentPrimary,
                      colorText: LColors.primary,
                      onPressed: () {
                        // Tutup dialog ketika pengguna memilih Batal
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.primary,
                      colorText: LColors.white,
                      onPressed: () {
                        resumeProject();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rejectProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Requests for Reject This Project?',
              style: LText.H3(color: LColors.red)),
          content: SizedBox(
            height: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure you want to reject this project?'),
                SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.red,
                      colorText: LColors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        _showAlasanRejectFormDialog(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 120,
                    child: ButtonSmall(
                      text: 'Cancel',
                      color: LColors.primary,
                      colorText: LColors.white,
                      onPressed: () {
                        // Tutup dialog ketika pengguna memilih Batal
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlasanRejectFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Type your reason for the reject request',
              style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 180,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //     'Upload your work file in cloud storage like Google Drive and paste the link here.'),
                  // SizedBox(height: 8),
                  TextField(
                    minLines: 3,
                    maxLines: 5,
                    controller: _alasanController,
                    decoration: InputDecoration(
                      // prefixIcon: Transform.rotate(
                      //     angle: 45 *
                      //         3.1415927 /
                      //         180, // Konversi 45 derajat ke radian
                      //     child: Icon(
                      //       Icons.insert_link_outlined,
                      //     )),
                      labelText: 'Your Reason',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Sudut melengkung
                        borderSide: BorderSide(
                          color: LColors.primary, // Warna border
                          width: 2.0, // Ketebalan border
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    SizedBox(
                      width: 120,
                      child: ButtonSmall(
                        text: 'Cancel',
                        color: LColors.transparentPrimary,
                        colorText: LColors.primary,
                        onPressed: () {
                          // Tutup dialog ketika pengguna memilih Batal
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ButtonSmall(
                        text: 'Send',
                        color: LColors.primary,
                        colorText: LColors.white,
                        onPressed: () {
                          rejectProject();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _pauseProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request to Pause This Project?',
              style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Are you sure you want to send this pending project request?'),
                SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.transparentPrimary,
                      colorText: LColors.primary,
                      onPressed: () {
                        Navigator.pop(context);
                        _showAlasanPendingFormDialog(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 120,
                    child: ButtonSmall(
                      text: 'Cancel',
                      color: LColors.primary,
                      colorText: LColors.white,
                      onPressed: () {
                        // Tutup dialog ketika pengguna memilih Batal
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlasanPendingFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Type your reason for the pending request',
              style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 180,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //     'Upload your work file in cloud storage like Google Drive and paste the link here.'),
                  // SizedBox(height: 8),
                  TextField(
                    minLines: 3,
                    maxLines: 5,
                    controller: _alasanController,
                    decoration: InputDecoration(
                      // prefixIcon: Transform.rotate(
                      //     angle: 45 *
                      //         3.1415927 /
                      //         180, // Konversi 45 derajat ke radian
                      //     child: Icon(
                      //       Icons.insert_link_outlined,
                      //     )),
                      labelText: 'Your Reason',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Sudut melengkung
                        borderSide: BorderSide(
                          color: LColors.primary, // Warna border
                          width: 2.0, // Ketebalan border
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    SizedBox(
                      width: 120,
                      child: ButtonSmall(
                        text: 'Cancel',
                        color: LColors.transparentPrimary,
                        colorText: LColors.primary,
                        onPressed: () {
                          // Tutup dialog ketika pengguna memilih Batal
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ButtonSmall(
                        text: 'Send',
                        color: LColors.primary,
                        colorText: LColors.white,
                        onPressed: () {
                          pauseProject();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLinkFileFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Send Your Work', style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Upload your work file in cloud storage like Google Drive and paste the link here.'),
                SizedBox(height: 8),
                TextField(
                  //minLines: 3,
                  //maxLines: 5,
                  controller: _linkFileController,
                  decoration: InputDecoration(
                    prefixIcon: Transform.rotate(
                        angle: 45 *
                            3.1415927 /
                            180, // Konversi 45 derajat ke radian
                        child: Icon(
                          Icons.insert_link_outlined,
                        )),
                    labelText: 'Link File',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Sudut melengkung
                      borderSide: BorderSide(
                        color: LColors.primary, // Warna border
                        width: 2.0, // Ketebalan border
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text('Client will review your work.',
                    textAlign: TextAlign.left),
                SizedBox(height: 20),
                Row(children: [
                  SizedBox(
                    width: 120,
                    child: ButtonSmall(
                      text: 'Cancel',
                      color: LColors.transparentPrimary,
                      colorText: LColors.primary,
                      onPressed: () {
                        // Tutup dialog ketika pengguna memilih Batal
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ButtonSmall(
                      text: 'Send',
                      color: LColors.primary,
                      colorText: LColors.white,
                      onPressed: () {
                        sendLinkFile();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

// lib/models/application_model.dart
class Application {
  final String applicationID;
  final String userID;
  final String vaid;
  final String clientID;
  final String status;
  final String tanggalPengajuan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String title;
  final String ratePrice;
  final String description;
  final String proof;

  Application({
    required this.applicationID,
    required this.userID,
    required this.vaid,
    required this.clientID,
    required this.status,
    required this.tanggalPengajuan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.title,
    required this.ratePrice,
    required this.description,
    required this.proof,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationID: '${json['ApplicationID']}',
      userID: '${json['UserID']}',
      vaid: '${json['Vaid']}',
      clientID: '${json['ClientID']}',
      status: json['Status'],
      tanggalPengajuan: json['TanggalPengajuan'],
      tanggalMulai: json['TanggalMulai'],
      tanggalSelesai: json['TanggalSelesai'],
      title: json['Title'],
      ratePrice: json['RatePrice'],
      description: json['Description'],
      proof: json['proof'],
    );
  }
}
