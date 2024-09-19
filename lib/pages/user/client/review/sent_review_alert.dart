import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';

class SentReviewAlert extends StatelessWidget {
  const SentReviewAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thank you for using Letter A services', style: LText.H3()),
      // content: Text('Ini adalah contoh popup alert.'),
      actions: <Widget>[
        Column(
          children: [
            Center(
                child: Icon(Icons.check_circle_outline,
                    color: LColors.primary, size: 160)),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                // Expanded(
                //   child: RoundedElevatedButtonWhite(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //     text: 'Cancel',
                //   ),
                // ),
                // SizedBox(width: 16),
                Expanded(
                  child: RoundedElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                        (route) =>
                            false, // Set the condition here. In this case, remove all other screens.
                      );
                    },
                    text: 'Okay',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
