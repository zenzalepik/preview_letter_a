import 'package:flutter/material.dart';

class LoginBerhasil extends StatefulWidget {
  final String? emailClient;
  final String? passwordClient;
  LoginBerhasil({Key? key, this.emailClient, this.passwordClient})
      : super(key: key);

  @override
  State<LoginBerhasil> createState() => _LoginBerhasilState();
}

class _LoginBerhasilState extends State<LoginBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Text(
        '${widget.emailClient} Login Berhasil ${widget.passwordClient}');
  }
}
