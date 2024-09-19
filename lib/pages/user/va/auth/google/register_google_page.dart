import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/pages/user/va/auth/google/update_profile_google_page.dart';
import 'package:letter_a/pages/user/va/auth/google/user_google_model.dart';

class FreeUserFormPage extends StatefulWidget {
  final FreeUserProfile freeUserProfile;
  // final String? idUser;
  // final String? nameUser;
  // final String? passwordUser;
  FreeUserFormPage(
      {
      // this.idUser,
      // this.nameUser,
      // this.passwordUser,
      required this.freeUserProfile});

  @override
  _FreeUserFormPageState createState() => _FreeUserFormPageState();
}

class _FreeUserFormPageState extends State<FreeUserFormPage> {
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
      _nameController.text = '${widget.freeUserProfile.name}';
      _idController.text =
          '${widget.freeUserProfile.id}'.replaceAll(RegExp(r'[^0-9]'), '');
      _emailController.text = '${widget.freeUserProfile.email}';
    });
    print(
        'check id ${widget.freeUserProfile.id.replaceAll(RegExp(r'[^0-9]'), '')}');
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
        'role': 'va',
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
            builder: (context) =>
                FreeProfilePage(freeUserProfile: widget.freeUserProfile),
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
          children: [],
        ),
      ),
    );
  }
}
