// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:letter_a/controller/config.dart';

class ApiService {
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

// lib/main.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApplicationScreen(),
    );
  }
}

class ApplicationScreen extends StatefulWidget {
  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late Future<Application?> _application;

  @override
  void initState() {
    super.initState();
    _application = ApiService()
        .fetchApplication(11); // Ganti dengan ApplicationID yang diinginkan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Details'),
      ),
      body: FutureBuilder<Application?>(
        future: _application,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final application = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text('Application ID: ${application.applicationID}'),
                  Text('User ID: ${application.userID}'),
                  Text('Vaid: ${application.vaid}'),
                  Text('Client ID: ${application.clientID}'),
                  Text('Status: ${application.status}'),
                  Text('Tanggal Pengajuan: ${application.tanggalPengajuan}'),
                  Text('Tanggal Mulai: ${application.tanggalMulai}'),
                  Text('Tanggal Selesai: ${application.tanggalSelesai}'),
                  Text('Title: ${application.title}'),
                  Text('Rate Price: ${application.ratePrice}'),
                  Text('Description: ${application.description}'),
                  Text('Proof: ${application.proof}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
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
