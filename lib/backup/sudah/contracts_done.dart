import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Contract',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UpdateContractPage(),
    );
  }
}

class UpdateContractPage extends StatefulWidget {
  @override
  _UpdateContractPageState createState() => _UpdateContractPageState();
}

class _UpdateContractPageState extends State<UpdateContractPage> {
  final TextEditingController _applicationIdController =
      TextEditingController();
  final TextEditingController _tanggalSelesaiController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Future<void> updateContract() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_update_detail_contract.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "tanggal_selesai": _tanggalSelesaiController.text,
        "status": _statusController.text,
      },
    );

    final data = json.decode(response.body);

    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui data: ${data['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contract'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _applicationIdController,
              decoration: InputDecoration(labelText: 'Application ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tanggalSelesaiController,
              decoration:
                  InputDecoration(labelText: 'Tanggal Selesai (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateContract,
              child: Text('Update Contract'),
            ),
          ],
        ),
      ),
    );
  }
}
