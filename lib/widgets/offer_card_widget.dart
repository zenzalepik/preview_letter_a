import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/pages/user/client/va/chat_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class ItemOfferWidget extends StatefulWidget {
  final String? title;
  final String? thumbnail;
  final String ratePrice;
  final String? tanggalPengajuan;
  final void Function()? onTap;
  final String? status;
  final bool? read;
  final String? role;

  const ItemOfferWidget({
    Key? key,
    this.title,
    this.onTap,
    this.thumbnail,
    required this.ratePrice,
    this.tanggalPengajuan,
    this.status,
    this.read,
    this.role,
  }) : super(key: key);

  @override
  State<ItemOfferWidget> createState() => _ItemOfferWidgetState();
}

class _ItemOfferWidgetState extends State<ItemOfferWidget> {
  String capitalizeEachWord(String text) {
    return text.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  // Fungsi untuk mengecek apakah string hanya mengandung angka dan titik
  bool isValidNumberWithDot(String value) {
    final regex = RegExp(r'^[0-9.]+$');
    return regex.hasMatch(value);
  }

  String formatRupiah(String amount) {
    // Menghapus karakter non-digit dan mengonversi ke integer
    final cleanedAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final int value = int.parse(cleanedAmount);
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  void initState() {
    super.initState();
    print('${widget.status}');
  }

  String formatTanggal(String tanggal) {
    // Parsing string ke DateTime
    DateTime dateTime = DateTime.parse(tanggal);
    // Memformat DateTime ke string dengan format yang diinginkan
    return DateFormat('dd-MM-yyyy').format(dateTime);
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
                      Container(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                              '${widget.thumbnail?.substring(0, 2).toUpperCase()}',
                              style: LText.H5()),
                        ),
                        decoration: BoxDecoration(
                            color: LColors.transparentPrimary,
                            borderRadius: BorderRadius.circular(16)),
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
                                  child: Text(
                                      '${capitalizeEachWord("${widget.title}")}',
                                      overflow: TextOverflow.ellipsis,
                                      style: LText.button(
                                          color: LColors.secondary)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${formatTanggal(widget.tanggalPengajuan ?? '')}',
                                      style: LText.labelDataTahun(
                                          color: LColors.black)),
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
                            child: isValidNumberWithDot(widget.ratePrice)
                                ? Text(
                                    formatRupiah(widget
                                        .ratePrice), // Format harga menjadi Rupiah
                                    overflow: TextOverflow.ellipsis,
                                    style: LText.H5(
                                        weight: widget.read == false ||
                                                widget.read == null
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: LColors.secondary
                                            .withOpacity(0.64)))
                                : Text(
                                    widget
                                        .ratePrice, // Format harga menjadi Rupiah
                                    overflow: TextOverflow.ellipsis,
                                    style: LText.H5(
                                        weight: widget.read == false ||
                                                widget.read == null
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: LColors.secondary
                                            .withOpacity(0.64)))),
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
            visible:
                widget.status == '' || widget.status == null ? false : true,
            child: Positioned(
                right: 12,
                top: 10,
                child: widget.status == 'pending'
                    ? SvgPicture.asset(
                        'assets/icons/img_label_application_pending.svg')
                    : widget.status == 'accepted'
                        ? SvgPicture.asset(
                            'assets/icons/img_label_application_accepted.svg')
                        : widget.status == 'done'
                            ? SvgPicture.asset(
                                'assets/icons/img_label_application_done.svg')
                            : widget.status == 'rejected'
                                ? SvgPicture.asset(
                                    'assets/icons/img_label_application_rejected.svg')
                                : SvgPicture.asset(
                                    'assets/icons/img_label_working.svg')),
          )
        ],
      ),
    );
  }
}
