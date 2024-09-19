import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/va/chat_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class ItemMessageWidget extends StatefulWidget {
  final String? text;
  final String? imageUrl;
  final String? chat;
  final String? lastTime;
  final String? lastTimeDate;
  final void Function()? onTap;
  final bool? working;
  final bool? read;
  final String? role;

  const ItemMessageWidget({
    Key? key,
    this.text,
    this.onTap,
    this.imageUrl,
    this.chat,
    this.lastTime,
    this.lastTimeDate,
    this.working,
    this.read,
    this.role,
  }) : super(key: key);

  @override
  State<ItemMessageWidget> createState() => _ItemMessageWidgetState();
}

class _ItemMessageWidgetState extends State<ItemMessageWidget> {
  @override
  void initState() {
    super.initState();
    print('${widget.working}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VAChatPage(
                          role: '${widget.role}' ?? '',
                          vaID: '',
                          chatId: '',
                          userId: '',
                          userPhoto: '',
                          userName: '',
                          lawanBicara: '',
                          lawanBicaraPhoto: '',
                        )),
              );
            }
          : widget.onTap,
      child: Stack(
        children: [
          Row(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.network(
                            '${widget.imageUrl}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${widget.text}',
                                      overflow: TextOverflow.ellipsis,
                                      style: LText.button(
                                          color: LColors.secondary)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${widget.chat}',
                                      overflow: TextOverflow.ellipsis,
                                      style: LText.labelDataTahun(
                                          weight: widget.read == false ||
                                                  widget.read == null
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: LColors.secondary
                                              .withOpacity(0.64))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                // color: LColors.,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                                '${widget.lastTimeDate} - ' +
                                    '${widget.lastTime}',
                                style: LText.labelDataTahun(
                                    color: LColors.black))),
                      ),
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
          Visibility(
            visible: widget.working == false || widget.working == null
                ? false
                : true,
            child: Positioned(
                right: 0,
                child: SvgPicture.asset('assets/icons/img_label_working.svg')),
          )
        ],
      ),
    );
  }
}
