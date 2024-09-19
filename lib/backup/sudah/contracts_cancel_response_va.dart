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
  int _selectedValue = 1;

  final TextEditingController _applicationIdController =
      TextEditingController(text: '11');
  final TextEditingController _alasanController =
      TextEditingController(text: 'Wah ya ngga bisa gitu bos...');
  final TextEditingController _approveRejectController =
      TextEditingController(text: 'approved');
  final TextEditingController _statusController =
      TextEditingController(text: 'reject');

  Future<void> cancelContract() async {
    final String apiUrl =
        "$server/api/v1/contracts/api_cancel_contract_response_va.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "alasan": _alasanController.text,
        "approveReject": _approveRejectController.text,
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
        title: Text('Response VA Cancel Contract'),
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
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value!;
                          _statusController.text = 'reject';
                          _approveRejectController.text = 'approved';
                          _alasanController.text = '';
                        });
                      },
                    ),
                    Text('Agree to Cancel'),
                  ],
                ),
                SizedBox(width: 32),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value!;
                          _statusController.text = 'running';
                          _approveRejectController.text = 'keeprunning';
                        });
                      },
                    ),
                    Text('Reject this request'),
                  ],
                ),
              ],
            ),
            TextField(
              controller: _approveRejectController,
              decoration: InputDecoration(labelText: 'ApproveReject'),
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
              child: Text('Response VA Cancel Contract'),
            ),
          ],
        ),
      ),
    );
  }
}
