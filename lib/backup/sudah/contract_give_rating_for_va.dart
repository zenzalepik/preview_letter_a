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
      title: 'Rating for VA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContractGiveRatingForVAPage(),
    );
  }
}

class ContractGiveRatingForVAPage extends StatefulWidget {
  @override
  _ContractGiveRatingForVAPageState createState() =>
      _ContractGiveRatingForVAPageState();
}

class _ContractGiveRatingForVAPageState
    extends State<ContractGiveRatingForVAPage> {
  int _selectedValue = 1;

  final TextEditingController _applicationIdController =
      TextEditingController(text: '9');
  final TextEditingController _ratingController =
      TextEditingController(text: '5');

  Future<void> cancelContract() async {
    final String apiUrl =
        "$server/api/v1/ratings/api_give_rating_for_va.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "rating": _ratingController.text,
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
        title: Text('Rating For VA'),
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
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cancelContract,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
