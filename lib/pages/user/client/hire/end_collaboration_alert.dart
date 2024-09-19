import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/hire/payment_page.dart';
import 'package:letter_a/pages/user/client/review/review_page.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';

class endHireVA extends StatefulWidget {
  const endHireVA({super.key});

  @override
  State<endHireVA> createState() => _endHireVAState();
}

class _endHireVAState extends State<endHireVA> {
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ReviewVAPage(aplicationId: '', vaName: '', contract: null, VAPhotoProfile: '',)),
                  // );
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
