import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/hire/payment_page.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';

class willHireVA extends StatefulWidget {
  final String vaID;
   willHireVA({super.key, required this.vaID});

  @override
  State<willHireVA> createState() => _willHireVAState();
}

class _willHireVAState extends State<willHireVA> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure to hire Andi Setia Budi?', style: LText.H3()),
      // content: Text('Ini adalah contoh popup alert.'),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: RoundedElevatedButtonWhite(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Cancel',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              vaID: '${widget.vaID}',
                            )),
                  );
                },
                text: 'Yes',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
