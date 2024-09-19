
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/auth/google/update_profile_google_page.dart';
import 'package:letter_a/pages/user/client/auth/google/user_google_model.dart';
import 'package:http/http.dart' as http;

class UserFormPage extends StatefulWidget {
  final UserProfile userProfile;
  // final String? idUser;
  // final String? nameUser;
  // final String? passwordUser;
  UserFormPage(
      {
      // this.idUser,
      // this.nameUser,
      // this.passwordUser,
      required this.userProfile});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _idController.text = '${widget.idUser}';
    // _nameController.text = '${widget.nameUser}';
    // _emailController.text = '${widget.passwordUser}';
    saveUser();
  }

  Future<void> inisiasi() async {
    setState(() {
      _nameController.text = '${widget.userProfile.name}';
      _idController.text =
          '${widget.userProfile.id}'.replaceAll(RegExp(r'[^0-9]'), '');
      _emailController.text = '${widget.userProfile.email}';
    });
    print(
        'check id ${widget.userProfile.id.replaceAll(RegExp(r'[^0-9]'), '')}');
  }

  Future<void> saveUser() async {
    await inisiasi();
    final String id = _idController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;

    final url = Uri.parse('https://letter-a.co.id/api/v1/auth/save_user.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'sub': id,
        'name': name,
        'email': email,
        'role': 'client',
      },
    );

    print('check id $id');
    print('check email $email');
    print('check name $name');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User saved successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userProfile: widget.userProfile),
          ),
        );
      } else {
        print('error save function');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving User Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
