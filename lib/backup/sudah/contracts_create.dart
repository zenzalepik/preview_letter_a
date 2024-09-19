import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:letter_a/controller/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Contract',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContractForm(),
    );
  }
}

class ContractForm extends StatefulWidget {
  @override
  _ContractFormState createState() => _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {
  final TextEditingController _applicationIdController =
      TextEditingController(text: '13');
  final TextEditingController _vaidController =
      TextEditingController(text: '0');
  final TextEditingController _userIdController =
      TextEditingController(text: '59');
  final TextEditingController _clientIdController =
      TextEditingController(text: '910');
  final TextEditingController _tanggalApproveController =
      TextEditingController(text: '2024-08-21');
  final TextEditingController _tanggalSelesaiController =
      TextEditingController(text: '2025-08-21');
  final TextEditingController _statusController =
      TextEditingController(text: 'running');
  final TextEditingController _ratingController =
      TextEditingController(text: '0.0');

  Future<void> _createContract() async {
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
          SnackBar(content: Text('Contract created successfully!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Contract'),
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
              controller: _vaidController,
              decoration: InputDecoration(labelText: 'Vaid'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'UserID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _clientIdController,
              decoration: InputDecoration(labelText: 'ClientID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tanggalApproveController,
              decoration:
                  InputDecoration(labelText: 'Tanggal Approve (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _tanggalSelesaiController,
              decoration:
                  InputDecoration(labelText: 'Tanggal Selesai (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'running'),
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createContract,
              child: Text('Create Contract'),
            ),
          ],
        ),
      ),
    );
  }
}
