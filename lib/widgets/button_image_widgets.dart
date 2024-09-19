import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';

class ButtonImageWidget extends StatelessWidget {
  final String? imgBg;
  final Color? colorBg;
  final Color? colorButton;
  final String? text;
  final VoidCallback? onTap;

  const ButtonImageWidget({
    Key? key,
    this.imgBg,
    this.colorBg,
    this.colorButton,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null ? () {} : onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 340,
                ),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: colorBg == null
                      ? colorButton == null
                          ? LColors.primary
                          : colorButton
                      : colorBg,
                  image: DecorationImage(
                    opacity: 0.64,
                    image: AssetImage(imgBg == '' || imgBg == null
                        ? 'assets/images/img_client_sign_up.png'
                        : '$imgBg'),
                    fit: BoxFit.cover, // Atur sesuai kebutuhan Anda
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.8), // Warna bayangan
                              spreadRadius: -5,
                              blurRadius: 64,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child:
                            // Icon(Icons.person_add, color: Colors.white, size: 80),
                            Icon(Icons.person, color: Colors.white, size: 104)),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.8), // Warna bayangan
                                  spreadRadius: -5,
                                  blurRadius: 64,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: RoundedElevatedButton(
                              onPressed: onTap == null ? () {} : onTap,
                              text: '$text',
                              color: colorButton == null
                                  ? LColors.primary
                                  : colorButton,
                              colorText: colorButton == null
                                  ? LColors.white
                                  : LColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
