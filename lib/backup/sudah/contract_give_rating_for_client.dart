import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:letter_a/controller/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating for Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContractGiveRatingForClientPage(),
    );
  }
}

class ContractGiveRatingForClientPage extends StatefulWidget {
  @override
  _ContractGiveRatingForClientPageState createState() =>
      _ContractGiveRatingForClientPageState();
}

class _ContractGiveRatingForClientPageState
    extends State<ContractGiveRatingForClientPage> {
  final TextEditingController _applicationIdController =
      TextEditingController(text: '9');
  double _rating = 3.0;

  Future<void> sendRating() async {
    final String apiUrl =
        "$server/api/v1/ratings/api_give_rating_for_client.php"; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "application_id": _applicationIdController.text,
        "ratingClient": _rating.toString(),
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
        title: Text('Rating For Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _applicationIdController,
              decoration: InputDecoration(labelText: 'Application ID'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Rating:',
              style: TextStyle(fontSize: 18),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendRating,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
