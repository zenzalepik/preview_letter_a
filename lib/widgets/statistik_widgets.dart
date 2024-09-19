import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class StatistikWidget extends StatefulWidget {
  final String? text;
  final void Function()? onTap;
  final double? jumlahUser;

  const StatistikWidget({Key? key, this.text, this.jumlahUser, this.onTap})
      : super(key: key);

  @override
  State<StatistikWidget> createState() => _StatistikWidgetState();
}

class _StatistikWidgetState extends State<StatistikWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('${widget.text}',
                        overflow: TextOverflow.ellipsis,
                        style: LText.button(color: LColors.secondary)),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: widget.jumlahUser! <= 1
                              ? LColors.yellow
                              : LColors.primary,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('${widget.jumlahUser.toString()}',
                          style: LText.labelData(
                              color: widget.jumlahUser! <= 1
                                  ? LColors.black
                                  : LColors.white))),
                ],
              ),
              SizedBox(
                height: 12,
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
