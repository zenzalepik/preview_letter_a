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
      title: 'Cancel Contract',
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
      TextEditingController(text: '11');
  final TextEditingController _alasanController =
      TextEditingController(text: 'Terlalu ribet');
  final TextEditingController _statusController =
      TextEditingController(text: 'reject');

  Future<void> cancelContract() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_cancel_contract.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "alasan": _alasanController.text,
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
        title: Text('Cancel Contract'),
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
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: _alasanController,
              decoration: InputDecoration(labelText: 'Alasan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cancelContract,
              child: Text('Cancel Contract'),
            ),
          ],
        ),
      ),
    );
  }
}
