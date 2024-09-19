import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/backup/sudah/applications_list.dart';
import 'package:letter_a/models/application_model.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';

class OfferDetailPage extends StatelessWidget {
  final Application application;

  OfferDetailPage({required this.application});

  @override
  Widget build(BuildContext context) {
    String formatRupiah(String amount) {
      // Menghapus karakter non-digit dan mengonversi ke integer
      final cleanedAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
      final int value = int.parse(cleanedAmount);
      final formatter = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(value);
    }

    String formatTanggal(String tanggal) {
      // Parsing string ke DateTime
      DateTime dateTime = DateTime.parse(tanggal);
      // Memformat DateTime ke string dengan format yang diinginkan
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    bool isValidNumberWithDot(String value) {
      final regex = RegExp(r'^[0-9.]+$');
      return regex.hasMatch(value);
    }

    return Scaffold(
      appBar: LAppBar(
        title: "Offer Detail",
        bgColor: LColors.primary,
        actions: <Widget>[],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            'assets/icons/icon_back.svg',
            width: 200, // atur lebar gambar sesuai kebutuhan Anda
            height: 200, // atur tinggi gambar sesuai kebutuhan Anda
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text('${application.title}', style: LText.H3())),
                ],
              ),
              Row(
                children: [
                  // Text('Cost:', style: LText.H5()),
                  Expanded(
                    child: isValidNumberWithDot(application.ratePrice)
                        ? Text(
                            application.ratePrice == '' ||
                                    application.ratePrice == 'null' ||
                                    application.ratePrice == null
                                ? ''
                                : '${formatRupiah(application.ratePrice)}',
                            style: LText.H5(color: LColors.primary))
                        : Text(application.ratePrice,
                            style: LText.H5(color: LColors.primary)),
                  ),
                  Visibility(
                    visible:
                        application.status == '' || application.status == null
                            ? false
                            : true,
                    child: Positioned(
                        right: 0,
                        child: application.status == 'pending'
                            ? SvgPicture.asset(
                                'assets/icons/img_label_application_pending.svg')
                            : application.status == 'accepted'
                                ? SvgPicture.asset(
                                    'assets/icons/img_label_application_accepted.svg')
                                : application.status == 'done'
                                    ? SvgPicture.asset(
                                        'assets/icons/img_label_application_done.svg')
                                    : application.status == 'rejected'
                                        ? SvgPicture.asset(
                                            'assets/icons/img_label_application_rejected.svg')
                                        : SvgPicture.asset(
                                            'assets/icons/img_label_working.svg')),
                  )
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              // SizedBox(height: 8),
              // SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 124,
                          child:
                              Text('Tanggal Mulai:', style: LText.labelData()),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 16),
                            SizedBox(
                              width: 4,
                            ),
                            Text('${formatTanggal(application.tanggalMulai)}',
                                style: LText.description()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 124,
                          child: Text('Tanggal Selesai:',
                              style: LText.labelData()),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 16),
                            SizedBox(
                              width: 4,
                            ),
                            Text('${formatTanggal(application.tanggalSelesai)}',
                                style: LText.description()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 8),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              SizedBox(height: 12),
              Text('Project Description:', style: LText.labelData()),
              SizedBox(height: 4),
              Text('''${application.description}''',
                  style: LText.descriptionLong()),
              SizedBox(height: 8),
              SizedBox(height: 12),
              Divider(height: 1, color: LColors.line),
              SizedBox(height: 12),
              Text('Proof of Payment', style: LText.labelData()),
              SizedBox(height: 4),
              application.proof.isNotEmpty
                  ? InteractiveViewer(
                      panEnabled: true, // Aktifkan penggeseran
                      minScale: 1.0, // Skala minimal
                      maxScale: 4.0, // Skala maksimal, bisa disesuaikan
                      child: GestureDetector(
                        onTap: () {
                          _showImageDialog(context,
                              'https://letter-a.co.id/api/v1/uploads/proofs/${application.proof}');
                        },
                        child: Image.network(
                          'https://letter-a.co.id/api/v1/uploads/proofs/${application.proof}',
                        ),
                      ),
                    )
                  : Text('No proof available'),
              SizedBox(
                height: 12,
              ),
              Opacity(
                opacity: 0.72,
                child: Row(
                  children: [
                    Text(
                      'Offer made on: ',
                    ),
                    Expanded(child: Divider(height: 1, color: LColors.line)),
                    Text(
                      ' ${formatTanggal(application.tanggalPengajuan)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
