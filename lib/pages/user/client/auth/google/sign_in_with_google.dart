import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';
import 'package:letter_a/pages/user/client/auth/google/update_profile_google_page.dart';
import 'package:letter_a/pages/user/client/auth/google/user_google_model.dart';
import 'package:mime/mime.dart'; // Untuk menentukan tipe MIME
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/oauth2/v2.dart' as oauth2;
import 'package:cached_network_image/cached_network_image.dart';

///////////////////////////////////////////////////
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: kIsWeb
      ? '748908392834-mncvork2lrh20bsmsipqfavct17tna2h.apps.googleusercontent.com'
      : null,
);

Future<GoogleSignInAccount?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    return googleUser;
  } catch (e) {
    print('Sign-in failed: $e');
    return null;
  }
}

Future<void> signOut() async {
  await _googleSignIn.signOut();
}

class StartSignInGoogle extends StatefulWidget {
  @override
  _StartSignInGoogleState createState() => _StartSignInGoogleState();
}

class _StartSignInGoogleState extends State<StartSignInGoogle> {
  GoogleSignInAccount? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    final user = await signInWithGoogle();
    if (user != null) {
      final authHeaders = await user.authHeaders;
      final accessToken = authHeaders['Authorization']?.split(' ')[1];

      if (accessToken != null) {
        print('Token akses: $accessToken');
        final userProfile = await _fetchUserProfile(accessToken);

        if (userProfile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userProfile: userProfile),
            ),
          );
        }
      }

      setState(() {
        _user = user;
      });
    }
  }

  Future<UserProfile?> _fetchUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me?personFields=names,emailAddresses,photos'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      try {
        print('Data Didapat');
        final userData = jsonDecode(response.body);
        print('Profil pengguna: $userData');

        if (userData['names'] != null &&
            userData['names'].isNotEmpty &&
            userData['emailAddresses'] != null &&
            userData['emailAddresses'].isNotEmpty &&
            userData['photos'] != null &&
            userData['photos'].isNotEmpty) {
          final String name = userData['names'][0]['displayName'];
          final String email = userData['emailAddresses'][0]['value'];
          final String photoUrl = '${userData['photos'][0]['url'] ?? ''}';
          final String id = userData['resourceName'];

          return UserProfile(
            name: name,
            email: email,
            photoUrl: photoUrl,
            id: id,
          );
        } else {
          print('Data profil tidak lengkap');
          return null;
        }
      } catch (e) {
        print('Error parsing user profile data: $e');
        return null;
      }
    } else {
      print('Gagal mendapatkan profil pengguna: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Sample'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }
}
