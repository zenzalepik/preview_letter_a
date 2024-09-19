import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/va/chat_page.dart';

class ApiSendRevisionContractService {
  final String apiUrl =
      '$server/api/v1/contracts/api-send-revision-contract.php';

  Future<void> sendRevisionMessage({
    required BuildContext context, // Menambahkan context
    required String user1Id,
    required String user2Id,
    required String authorId,
    required String author_first_name,
    required String author_image_url,
    required String VAPhotoProfile,
    required String VAName,
  }) async {
    try {
      // Data yang akan dikirim
      final Map<String, dynamic> requestData = {
        'user_1_id': user1Id,
        'user_2_id': user2Id,
        'author_id': authorId,
        'author_first_name': author_first_name,
        'author_image_url': author_image_url,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'created_at_column': DateTime.now().toString().split('.').first,
      };

      // Header untuk permintaan
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Mengirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      // Memeriksa respons
      if (response.statusCode == 200) {
        print('$requestData');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          print(
              "Pesan revisi terkirim dengan chat_id: ${responseData['chat_id']}");
          Navigator.push(
            context,
            MaterialPageRoute(
                //CreateNewChat
                builder: (context) => VAChatPage(
                      role: '',
                      vaID: '$user2Id',
                      chatId: '${responseData['chat_id']}',
                      userId: '$user1Id',
                      userPhoto: '$author_image_url',
                      userName: '$author_first_name',
                      lawanBicara: '$VAName',
                      lawanBicaraPhoto: '$VAPhotoProfile',
                    )),
          );
        } else {
          print("Gagal mengirim pesan: ${responseData['message']}");
        }
      } else {
        print("Gagal menghubungi server: ${response.statusCode}");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }
}
