import 'package:flutter/material.dart';
import 'package:letter_a/backup/sudah/applications_list.dart';
import 'package:letter_a/models/application_model.dart';

class ApplicationDetailPage extends StatelessWidget {
  final Application application;

  ApplicationDetailPage({required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Aplikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${application.title}',
            ),
            Text(
              'Rate/Cost: ${application.ratePrice}',
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${application.status}',
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal Pengajuan: ${application.tanggalPengajuan}',
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal Mulai: ${application.tanggalMulai}',
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal Selesai: ${application.tanggalSelesai}',
            ),
            SizedBox(height: 8),
            Text(
              'Description:',
            ),
            Text(
              application.description,
            ),
            SizedBox(height: 8),
            application.proof.isNotEmpty
                ? Image.network(
                    'https://letter-a.co.id/api/v1/uploads/proofs/${application.proof}')
                : Text('No proof available'),
          ],
        ),
      ),
    );
  }
}
