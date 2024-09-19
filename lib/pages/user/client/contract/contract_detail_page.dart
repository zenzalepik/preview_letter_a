import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:letter_a/backup/contracts_list.dart_text';
import 'package:letter_a/controller/config.dart';
// import 'package:letter_a/main.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/send_revision_contract_controller.dart';
import 'package:letter_a/controller/user_profile_controller.dart';
import 'package:letter_a/main.dart';
import 'package:letter_a/models/contract_model.dart';
import 'package:letter_a/pages/user/client/message/list_message_page.dart';
import 'package:letter_a/pages/user/client/review/review_page.dart';
import 'package:letter_a/pages/user/va/message/free_list_message_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiGetAplicationDetailService {
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

class ContractDetailScreen extends StatefulWidget {
  final Contract contract;

  ContractDetailScreen({required this.contract});

  @override
  State<ContractDetailScreen> createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  late Future<Application?> _application;
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  bool hasError = false;
  final UserService userService = UserService('$server'); // Sesuaikan server
  String VAName = '';
  String ClientName = '';
  String ClientPhoto = '';
  String VAId = '';
  String ClientId = '';
  String VAPhotoProfile = '';

  @override
  void initState() {
    super.initState();
    _loadUserVAProfile();
    _loadUserClientProfile();
    _application = ApiGetAplicationDetailService()
        .fetchApplication(int.parse(widget.contract.application_id));
    print('widget.contract.Rating ${widget.contract.Rating}');
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
          VAPhotoProfile = '${userProfile!['profileImage'] ?? 'N/A'}';
          VAId = '${userProfile!['id'] ?? 'N/A'}';
          isLoading = false;
          print('ClientId $ClientId');
          print('VAId $VAId');
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
          ClientPhoto = '${userProfile!['profileImage'] ?? 'N/A'}';
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

// Fungsi untuk membuka link di browser
  void _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  Future<void> approveRejectProject() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_reject_contract_approve_by_client.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'reject',
        "ApprovalClient": 'approved',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.red,
            content: Text("This project has been rejected",
                style: TextStyle(color: LColors.white))),
      );

      // Tunggu 3 detik sebelum pindah ke halaman Home
      await Future.delayed(Duration(seconds: 3));

      // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> approvePendingProject() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_pending_contract_approve_by_client.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'pending',
        "ApprovalClient": 'approved',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.yellow,
            content: Text("This project has been paused",
                style: TextStyle(color: LColors.black))),
      );

      // Tunggu 3 detik sebelum pindah ke halaman Home
      await Future.delayed(Duration(seconds: 3));

      // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> approveDoneProject() async {
    String _tanggalSelesai = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String apiUrl =
        "$server/api/v1/contracts/api_done_contract_approve_by_client.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'done',
        "ApprovalClient": 'approved',
        "TanggalSelesai": '$_tanggalSelesai',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text("This project has done!",
                style: TextStyle(color: LColors.white))),
      );

      // Tunggu 3 detik sebelum pindah ke halaman Home
      await Future.delayed(Duration(seconds: 3));

      // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ReviewVAPage(
                  aplicationId: '${widget.contract.application_id}',
                  vaName: '$VAName',
                  contract: widget.contract,
                  VAPhotoProfile: '$VAPhotoProfile',
                  vaId: '$VAId',
                )),
        // MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> declineRejectProject() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_reject_contract_decline_by_client.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'running',
        "ApprovalClient": '',
        "Alasan": '',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text("Reject request has been decline",
                style: TextStyle(color: LColors.white))),
      );

      // Tunggu 3 detik sebelum pindah ke halaman Home
      await Future.delayed(Duration(seconds: 3));

      // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> declinePendingProject() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_pending_contract_decline_by_client.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": '${widget.contract.application_id}',
        "status": 'running',
        "ApprovalClient": '',
        "Alasan": '',
      },
    );

    final data = json.decode(response.body);
    print('$data');

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary,
            content: Text("Pause project request has been decline",
                style: TextStyle(color: LColors.white))),
      );

      // Tunggu 3 detik sebelum pindah ke halaman Home
      await Future.delayed(Duration(seconds: 3));

      // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ListMessagePage(index: '2')),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${data['message']}")),
      );
    }
  }

  Future<void> sendRevisionMessage() async {
    await _loadUserVAProfile();
    await _loadUserClientProfile();
    ApiSendRevisionContractService apiService =
        ApiSendRevisionContractService();

    // Memanggil fungsi untuk mengirim pesan
    apiService.sendRevisionMessage(
      context: context,
      user1Id: ClientId, // ID pengguna pertama
      user2Id: VAId, // ID pengguna kedua
      authorId: ClientId, // ID pengirim (penulis pesan)
      author_first_name: ClientName,
      author_image_url: ClientPhoto,
      VAPhotoProfile: VAPhotoProfile,
      VAName: VAName,
    );
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
                                    : (widget.contract.ApprovalClient ==
                                                'approved') &&
                                            widget.contract.Status == 'reject'
                                        ? LColors.red
                                        : (widget.contract.ApprovalClient !=
                                                    'approved') &&
                                                widget.contract.Status ==
                                                    'reject'
                                            ? LColors.red
                                            : widget.contract.Status ==
                                                    'failded'
                                                ? LColors.failed
                                                : widget.contract.Status ==
                                                        'review'
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
                            (widget.contract.Status == 'done') &&
                                    (widget.contract.Rating != '0.00' &&
                                        widget.contract.Rating != '0' &&
                                        widget.contract.Rating != '' &&
                                        widget.contract.Rating != 'null' &&
                                        widget.contract.Rating != null)
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
      bottomNavigationBar: (widget.contract.LinkFile != '' &&
                  widget.contract.LinkFile != null &&
                  widget.contract.LinkFile != 'null') &&
              (widget.contract.Status == 'done')
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: LColors.white, boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  color: Colors.grey,
                )
              ]),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: widget.contract.Rating == '0.00' ||
                            widget.contract.Rating == '0' ||
                            widget.contract.Rating == '' ||
                            widget.contract.Rating == 'null' ||
                            widget.contract.Rating == null
                        ? 140
                        : 80,
                    child: Column(
                      children: [
                        widget.contract.Rating == '0.00' ||
                                widget.contract.Rating == '0' ||
                                widget.contract.Rating == '' ||
                                widget.contract.Rating == 'null' ||
                                widget.contract.Rating == null
                            ? GestureDetector(
                                onTap: () {
                                  // Arahkan ke halaman Home (ganti HomePage() dengan halaman yang sesuai)
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewVAPage(
                                              aplicationId:
                                                  '${widget.contract.application_id}',
                                              vaName: '$VAName',
                                              contract: widget.contract,
                                              VAPhotoProfile: '$VAPhotoProfile',
                                              vaId: '$VAId',
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
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star_border_outlined,
                                                color: LColors.white),
                                            SizedBox(width: 4),
                                            Text('Give Rating For Your VA',
                                                textAlign: TextAlign.center,
                                                style: LText.H5(
                                                    color: LColors.white)),
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
                                                  color: LColors.primary
                                                      .withOpacity(0.44),
                                                  offset: Offset(0.0, 12.0))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        widget.contract.Rating == '0.00' ||
                                widget.contract.Rating == '0' ||
                                widget.contract.Rating == '' ||
                                widget.contract.Rating == 'null' ||
                                widget.contract.Rating == null
                            ? SizedBox(
                                height: 16,
                              )
                            : SizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Text('This project has been DONE',
                                    textAlign: TextAlign.center,
                                    style: LText.H5(color: LColors.primary)),
                                decoration: BoxDecoration(
                                    color: LColors.black,
                                    border: Border.all(
                                        width: 4, color: LColors.primary),
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ))
          : (widget.contract.LinkFile != '' &&
                      widget.contract.LinkFile != null &&
                      widget.contract.LinkFile != 'null') &&
                  (widget.contract.Status == 'review')
              ? Container(
                  height: 148,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: LColors.white, boxShadow: [
                    BoxShadow(
                      blurRadius: 32,
                      color: Colors.grey,
                    )
                  ]),
                  child: Column(
                    children: [
                      Text('Your VA has sent the job file',
                          style: LText.subtitle()),
                      GestureDetector(
                        onTap: () {
                          _launchURL('${widget.contract.LinkFile}');
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                                angle: 45 *
                                    3.1415927 /
                                    180, // Konversi 45 derajat ke radian
                                child: Icon(Icons.insert_link_outlined,
                                    color: LColors.primary, size: 20)),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Open file link',
                                style: LText.button(color: LColors.primary)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonSmall(
                              onPressed: () {
                                // _resumeProjectDialog(context);
                                sendRevisionMessage();
                                print('----');
                              },
                              color: LColors.yellow,
                              colorText: LColors.black,
                              text: 'Send Revision',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ButtonSmall(
                              onPressed: () {
                                _approveDoneProjectDialog(context);
                                // _resumeProjectDialog(context);
                              },
                              color: LColors.primary,
                              colorText: LColors.white,
                              text: 'Approve File & Done',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
              : (widget.contract.Status == 'pending') &&
                      (widget.contract.ApprovalClient == '')
                  ? Container(
                      height: 184,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration:
                          BoxDecoration(color: LColors.white, boxShadow: [
                        BoxShadow(
                          blurRadius: 32,
                          color: Colors.grey,
                        )
                      ]),
                      child: Column(children: [
                        Text('Your VA request for pause this project',
                            style: LText.subtitle()),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            _reasonDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: LColors.yellow.withOpacity(0.08),
                                border: Border.all(
                                    width: 1,
                                    color: LColors.yellow.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Reason:', style: LText.labelData()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis
                                            .vertical, // Membuat scroll secara horizontal
                                        child: Text(
                                          '${widget.contract.Alasan}',
                                          style: LText.description(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonSmall(
                                onPressed: () {
                                  _approvePendingProjectDialog(context);
                                  // _rejectProjectDialog(context);
                                  // Navigator.pop(context);
                                },
                                color: LColors.yellow,
                                colorText: LColors.black,
                                text: 'Accept Pending',
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: ButtonSmall(
                                onPressed: () {
                                  _declinePendingProjectDialog(context);
                                  // _resumeProjectDialog(context);
                                },
                                color: LColors.transparentPrimary,
                                colorText: LColors.primary,
                                text: 'Decline',
                              ),
                            ),
                          ],
                        )
                      ]))
                  : (widget.contract.Status == 'pending') &&
                          (widget.contract.ApprovalClient == 'approved')
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration:
                              BoxDecoration(color: LColors.white, boxShadow: [
                            BoxShadow(
                              blurRadius: 32,
                              color: Colors.grey,
                            )
                          ]),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.all(16),
                                child: Text('This project is currently paused',
                                    textAlign: TextAlign.center,
                                    style: LText.H5(color: LColors.yellow)),
                                decoration: BoxDecoration(
                                    color: LColors.yellow.withOpacity(0.12),
                                    border: Border.all(
                                        width: 4, color: LColors.yellow),
                                    borderRadius: BorderRadius.circular(16)),
                              )),
                            ],
                          ))
                      : (widget.contract.Status == 'reject') &&
                              (widget.contract.ApprovalClient == '')
                          ? Container(
                              height: 184,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: LColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 32,
                                      color: Colors.grey,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  Text(
                                      'Your VA request for reject this project',
                                      style: LText.subtitle()),
                                  SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () {
                                      _reasonDialog(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: LColors.red.withOpacity(0.08),
                                          border: Border.all(
                                              width: 1,
                                              color:
                                                  LColors.red.withOpacity(0.4)),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Reason:',
                                                  style: LText.labelData()),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${widget.contract.Alasan}',
                                                  style: LText.description(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ButtonSmall(
                                          onPressed: () {
                                            _approveRejectProjectDialog(
                                                context);
                                            // Navigator.pop(context);
                                          },
                                          color: LColors.red,
                                          colorText: LColors.white,
                                          text: 'Accept & Reject',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: ButtonSmall(
                                          onPressed: () {
                                            _declineRejectProjectDialog(
                                                context);
                                            // _resumeProjectDialog(context);
                                          },
                                          color: LColors.transparentPrimary,
                                          colorText: LColors.primary,
                                          text: 'Decline',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                          : (widget.contract.Status == 'reject') &&
                                  (widget.contract.ApprovalClient == 'approved')
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: LColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 32,
                                          color: Colors.grey,
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                            'This project has been rejected',
                                            textAlign: TextAlign.center,
                                            style: LText.labelData(
                                                color: LColors.red)),
                                        decoration: BoxDecoration(
                                            color:
                                                LColors.red.withOpacity(0.24),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                      )),
                                    ],
                                  ))
                              : widget.contract.Status == 'running'
                                  ? SizedBox()
                                  : SizedBox(),
    );
  }

  void _reasonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16), // Menghilangkan margin default
          child: AlertDialog(
            contentPadding: EdgeInsets
                .zero, // Menghilangkan padding antara dialog dengan isinya
            titlePadding: EdgeInsets.all(16),
            title: Text("VA Reason", style: LText.H3(color: LColors.primary)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        // width: 120,
                        child: Column(
                          children: [
                            Text(
                              '${widget.contract.Alasan}',
                              style: LText.description(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ButtonSmall(
                text: 'Close',
                color: LColors.transparentPrimary,
                colorText: LColors.primary,
                onPressed: () {
                  // Tutup dialog ketika pengguna memilih Batal
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
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

  void _approveRejectProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure to Approve Reject This Project?',
              style: LText.H3(color: LColors.red)),
          content: SizedBox(
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Are you sure you want to reject this project?'),
                // SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.red,
                      colorText: LColors.white,
                      onPressed: () {
                        approveRejectProject();
                        Navigator.pop(context);
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

  void _approvePendingProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure to Approve Pause This Project?',
              style: LText.H3(color: LColors.black)),
          content: SizedBox(
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Are you sure you want to reject this project?'),
                // SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.yellow,
                      colorText: LColors.black,
                      onPressed: () {
                        approvePendingProject();
                        Navigator.pop(context);
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

  void _approveDoneProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure This Project Already Done?',
              style: LText.H3(color: LColors.primary)),
          content: SizedBox(
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Are you sure you want to reject this project?'),
                // SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.primary,
                      colorText: LColors.white,
                      onPressed: () {
                        approveDoneProject();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
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
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _declineRejectProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decline This Reject Request?',
              style: LText.H3(color: LColors.black)),
          content: SizedBox(
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Are you sure you want to reject this project?'),
                // SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.transparentPrimary,
                      colorText: LColors.primary,
                      onPressed: () {
                        declineRejectProject();
                        Navigator.pop(context);
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

  void _declinePendingProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decline This Pause Project Request?',
              style: LText.H3(color: LColors.black)),
          content: SizedBox(
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Are you sure you want to reject this project?'),
                // SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ButtonSmall(
                      text: 'Yes',
                      color: LColors.transparentPrimary,
                      colorText: LColors.primary,
                      onPressed: () {
                        declinePendingProject();
                        Navigator.pop(context);
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
