import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class MenuArrowWidget extends StatelessWidget {
  final String? text;
  final void Function()? onTap;

  const MenuArrowWidget({Key? key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('$text',
                        style: LText.button(color: LColors.primary)),
                  ),
                  Icon(Icons.arrow_right)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: LColors.line,
              )
            ],
          )),
        ],
      ),
    );
  }
}
