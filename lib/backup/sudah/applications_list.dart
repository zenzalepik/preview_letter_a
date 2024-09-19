import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/backup/sudah/application_detail_page.dart';
import 'dart:convert';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/application_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApplicationList(),
    );
  }
}

class ApplicationList extends StatefulWidget {
  @override
  _ApplicationListState createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  late Future<List<Application>> _applications;

  @override
  void initState() {
    super.initState();
    _applications = fetchApplications();
  }

  Future<List<Application>> fetchApplications() async {
    final response = await http
        .get(Uri.parse('$server/api/v1/applications/api_get_applications.php'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody); // Debug output

      List<dynamic> data = responseBody['data'];
      return data.map((json) => Application.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Aplikasi')),
      body: FutureBuilder<List<Application>>(
        future: _applications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada aplikasi ditemukan'));
          } else {
            List<Application> applications = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: applications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicationDetailPage(
                          application: applications[index],
                        ),
                      ),
                    );
                  },
                  leading: Image.network(
                      '$server/api/v1/uploads/proofs/${applications[index].proof}'),
                  title: Text('${applications[index].title}'),
                  subtitle: Text('Status: ${applications[index].status}'),
                  trailing: Text('${applications[index].tanggalPengajuan}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}