import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/config.dart';

void main() {
  runApp(AverageRatingApp());
}

class AverageRatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AverageRatingScreen(),
    );
  }
}

class AverageRatingScreen extends StatefulWidget {
  @override
  _AverageRatingScreenState createState() => _AverageRatingScreenState();
}

class _AverageRatingScreenState extends State<AverageRatingScreen> {
  double? averageRating;
  List<dynamic> contracts = [];
  bool isLoading = true;
  final int userId = 59; // Ubah dengan UserID yang diinginkan

  @override
  void initState() {
    super.initState();
    fetchAverageRatingAndContracts();
  }

  Future<void> fetchAverageRatingAndContracts() async {
    final url =
        '$server/api/v1/ratings/api_average_rating_va.php?userid=$userId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          averageRating = jsonData['average_rating'].toDouble();
          contracts = jsonData['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Average Rating App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average Rating: ${averageRating?.toStringAsFixed(1) ?? 'N/A'}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: contracts.length,
                      itemBuilder: (context, index) {
                        final contract = contracts[index];
                        return Card(
                          child: ListTile(
                            title: Text('Contract ID: ${contract['id']}'),
                            subtitle: Text(
                                'Rating: ${contract['Rating']}, Status: ${contract['Status']}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
