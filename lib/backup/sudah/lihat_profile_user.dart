import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/config.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    const String server = 'https://letter-a.co.id'; // Ganti dengan server yang benar
    final url = '$server/api/v1/info/api_user_data.php?id=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userProfile = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Failed to load profile'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        'Full Name: ${userProfile!['fullName'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${userProfile!['email'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Place of Birth: ${userProfile!['placeOfBirth'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date of Birth: ${userProfile!['dateOfBirth'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'WhatsApp: ${userProfile!['whatsapp'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Facebook: ${userProfile!['facebook'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Instagram: ${userProfile!['instagram'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      userProfile!['profileImage'] != null
                          ? Image.network(
                              '$server/${userProfile!['profileImage']}',
                              height: 100,
                              width: 100,
                            )
                          : Text('No profile image available'),
                    ],
                  ),
                ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfileScreen(userId: '59'), // Ganti dengan ID user yang sesuai
    );
  }
}
